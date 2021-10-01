#!/usr/bin/env python3
""" Gets ATOM documents from FPDS and into PostgreSQL.

William Muir (2019). CC0 1.0.

Pulls down one day off of the ATOM feeds (PUBLIC, DELETED), verifies
that XML is well-formed, verifies compliance to the ATOM specification
(RFC4287)* and drops the ATOM document into PostgreSQL.

*Technically the feed does not comply with RFC4287, although FPDS
claims otherwise.  For instance, RFC4287 has no concept of a `modified`
tag, which FPDS includes, but does _require_ an `updated` tag, which
FPDS fails to include.  A modified RelaxNG script is on github and is
downloaded below for validation of ATOM documents.
"""

import datetime
import io
import logging
import time
import urllib.parse
import uuid

from lxml import etree
# import psycopg2
import requests
from requests.exceptions import ConnectTimeout, ReadTimeout, Timeout

# from db_parms import db_parms

logging.basicConfig(level=logging.INFO)
LOGGER = logging.getLogger(__name__)

NAMESPACES = {
    "atom": "http://www.w3.org/2005/Atom",
    "fpds": "http://www.fpdsng.com/FPDS",
}

RELAX = "/".join(
    [
        "https://raw.githubusercontent.com",
        "wamuir/fpds-lxml-validation/master/RelaxNG/rfc4287-FPDS.rng",
    ]
)

RESPONSE = requests.get(RELAX)
ATOM_SCHEMA = etree.parse(io.BytesIO(RESPONSE.content))
VALIDATOR = etree.RelaxNG(ATOM_SCHEMA)


# def create_tables(connection):
#     """ Create `atom` schema and `documents` table.
#     """

#     cursor = connection.cursor()
#     cursor.execute("""CREATE SCHEMA IF NOT EXISTS atom""")
#     cursor.execute(
#         """
#         CREATE TABLE IF NOT EXISTS atom.documents (
#             id UUID PRIMARY KEY,
#             feed CHAR(10) NOT NULL,
#             lastmoddate DATE NOT NULL,
#             start INTEGER NOT NULL,
#             document TEXT NOT NULL
#           );
#         """
#     )
#     cursor.execute(
#         """
#         CREATE INDEX IF NOT EXISTS lastmoddate_idx
#         ON atom.documents
#         USING BRIN (lastmoddate);
#         """
#     )

#     cursor.close()
#     return True


# def get_feed(
#     connection, feed_date, feed_name, feed_start=0, feed_version="1.5"
def get_feed(
    feed_date, feed_name, feed_start=0, feed_version="1.52"
):
    """ Fetch ATOM feed, validate against ATOM schema, write+rinse+repeat

    Sample PUBLIC url:
        https://www.fpds.gov/ezsearch/FEEDS/ATOM?s=FPDS&FEEDNAME=PUBLIC
          &VERSION=1.5.1&q=LAST_MOD_DATE:[2017/10/28,2017/10/28]&start=0

    Sample DELETED url:
        https://www.fpds.gov/ezsearch/FEEDS/ATOM?s=FPDS&FEEDNAME=DELETED
          &VERSION=1.5.1&q=LAST_MOD_DATE:[2017/11/04,2017/11/04]&start=0

    Args:
        feed_date (str): the date as YYYY/MM/DD or YYYY-MM-DD (ISO)
        feed_name (str): valid FPDS ATOM feedname (i.e., PUBLIC, DELETED)
        feed_start (int): feed is paginated // default = 0
        feed_version (str): max version // default = 1.5
        connection (obj): PostgreSQL connection object
    """

    endpoint = "https://www.fpds.gov/ezsearch/FEEDS/ATOM"

    query_string = urllib.parse.urlencode(
        {
            "s": "FPDS",
            "FEEDNAME": feed_name,
            "VERSION": feed_version,
            "q": "LAST_MOD_DATE:[{0},{0}]".format(
                feed_date.isoformat()
            ),
            "start": feed_start,
        }
    )

    feed_url = "?".join([endpoint, query_string])

    session = requests.Session()
    # cursor = connection.cursor()

    # Loop through ATOM pagination.
    while feed_url is not None:

        LOGGER.debug("URL is %s", feed_url)

        try:
            document = fetch_atom(session, feed_url)
            print(f"document: {document}")
            validate_atom(document)
            # cursor.execute(
            #     """
            #     INSERT INTO atom.documents (
            #       id, feed, lastmoddate, start, document
            #     ) VALUES (%s, %s, %s, %s, %s);
            #     """,
            #     [
            #         str(uuid.uuid4()),
            #         feed_name,
            #         feed_date,
            #         feed_start,
            #         document,
            #     ],
            # )

        # Log, rollback database changes and bail.
        #
        # This is definitely inefficient, but the feeds can be fickle
        # so it is safer to start again from the beginning of the day
        # if things begin to go awry.
        except Exception as exc:
            LOGGER.error(str(exc))
            # connection.rollback()
            exit(1)

        feed_start += 10
        feed_url = next_atom(document)

    return True


def fetch_atom(session, feed_url):
    """ Grab the document from the url.
    """

    try:
        response = session.get(
            feed_url,
            proxies=None,
            allow_redirects=True,
            timeout=(15.05, 60.05),
            stream=False,
        )
        if response.ok and response.status_code == 200:
            payload = response.content.decode("utf-8")

    # Log timeout, sleep for a minute and then try again.
    except (ConnectTimeout, ReadTimeout, Timeout) as exc:
        LOGGER.warning(str(exc))
        time.sleep(60)
        return fetch_atom(session, feed_url)

    return payload


def validate_atom(document):
    """ Validate the ATOM document.
    """

    # Check if XML is well-formed
    parser = etree.XMLParser()
    tree = etree.parse(io.BytesIO(document.encode()), parser)

    # Check if ATOM document is valid against quasi-ATOM specification
    if not VALIDATOR.validate(tree):
        raise Exception("Failed to validate ATOM document.")


def next_atom(document):
    """ Parse `link` XML node for next feed; return href (or None).
    """

    parser = etree.XMLParser()
    tree = etree.parse(io.BytesIO(document.encode()), parser)
    xpath = '/atom:feed/atom:link[@rel="next"]'
    link = tree.xpath(xpath, namespaces=NAMESPACES)
    if not link:
        return None
    return link[0].attrib["href"]


# def query_dates(connection):
#     """ Get dates to download from feed.
#     """

#     statement = """
#         SELECT i::DATE
#         FROM GENERATE_SERIES(
#             '2014-10-01',
#             /* CURRENT_DATE - 91, */
#             CURRENT_DATE - 1,
#             '1 DAY'::INTERVAL
#         ) i
#         LEFT OUTER JOIN (
#             SELECT DISTINCT(lastmoddate) FROM atom.documents
#         ) j
#         ON i::DATE = j.lastmoddate::DATE
#         WHERE j.lastmoddate IS NULL
#         ORDER BY i::DATE DESC;
#     """
#     cursor = connection.cursor()
#     cursor.execute(statement)
#     feed_dates = [row[0] for row in cursor.fetchall()]
#     return feed_dates


# def count_dates():
#     """ For convenience and for use by slurm job script.
#     """

#     try:
#         with psycopg2.connect(**db_parms) as connection:
#             create_tables(connection)
#             feed_dates = query_dates(connection)
#             print(len(feed_dates))

#     except Exception as exc:
#         LOGGER.error(str(exc))
#         exit(1)

#     logging.shutdown()
#     exit(0)


if __name__ == "__main__":

    FEEDS = ["PUBLIC", "DELETED"]
    DATE = datetime.date(2020,4,1)
    
    # with psycopg2.connect(**db_parms) as CONN:

    #     create_tables(CONN)

        # Pull ATOM feed for just one date, see slice.
        # for DATE in query_dates(CONN)[:1]:

            # LOGGER.info(
            #     "Started ingesting for %s at %s",
            #     DATE,
            #     datetime.datetime.now(),
            # )

            # # Make sure we've got all feeds in prior to committing.
            # if all(
            #     get_feed(
            #         feed_date=DATE, feed_name=FEED, connection=CONN
            #     )
            #     for FEED in FEEDS
            # ):

            #     CONN.commit()
            #     LOGGER.info(
            #         "Stopped ingesting for %s at %s",
            #         DATE,
            #         datetime.datetime.now(),
            #     )

            # else:
            #     LOGGER.error("Non-zero feed return.")
            #     CONN.rollback()
            #     logging.shutdown()
            #     exit(1)
            
            

    LOGGER.info(
        "Started ingesting for %s at %s",
        DATE,
        datetime.datetime.now(),
    )

    # Make sure we've got all feeds in prior to committing.
    if all(
        get_feed(
            feed_date=DATE, feed_name=FEED
        )
        for FEED in FEEDS
    ):

        # CONN.commit()
        LOGGER.info(
            "Stopped ingesting for %s at %s",
            DATE,
            datetime.datetime.now(),
        )

    else:
        LOGGER.error("Non-zero feed return.")
        # CONN.rollback()
        logging.shutdown()
        exit(1)
        
    logging.shutdown()
    exit(0)
