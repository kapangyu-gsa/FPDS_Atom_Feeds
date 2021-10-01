using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Xml;
using System.Web;
using System.Net;
using System.IO;
using System.Net.Mail;




namespace GetXML
{
    class PullAtom
    {
        public string AtomXML(string URL,StringBuilder sb, string AwardOrIDV = null, string ContractingOrFunding = null, string Agency = null)
        { 
            // This code will build the first pull or process sequestial requests.
            // Key Note:  Pass Empty String for URL on first pull ("")
            //              and provide values for AwardOrIDV, ContractingOrFunding (can be null if processing IDV), Agency (can be null if processing IDV)
            // the Return is an XML string

            
            string xmlDOC = "";


                // This is where you set the first pull.  In future this will have to be pulled from SQL Server to get date range of pull.
                // We are still implementing a pull from the past two days.  The pull is fast enough to handle the extra day and will catch anything missed.
                if (URL == "")
                {
                    string today = DateTime.Now.ToString("yyyy/MM/dd"); 
                                   // "2015/01/01"; //
                    string sd = DateTime.Now.AddDays(-1).ToString("yyyy/MM/dd"); 
                                //   "2013/10/01"; //

                    URL = "https://www.fpds.gov/dbsight/FEEDS/ATOM?FEEDNAME=PUBLIC&q=";
                    //URL += "PIID:\"GS07F0376W\"";
                    URL += "LAST_MOD_DATE:[" + sd + "," + today + "]";
                    URL += AwardOrIDV != null ? " CONTRACT_TYPE:\"" + AwardOrIDV.ToUpper() + "\"" : "";
                    URL += Agency != null ? " " + ContractingOrFunding + ":\"" + Agency + "\"" : "";
                    URL += "&version=1.4.4";


                    Console.WriteLine();
                    Console.WriteLine(URL);
                    sb.AppendLine();
                    sb.AppendLine(URL);
                }
                
                // Give update on every 1000 records.
                if (URL.Substring(URL.Length - 3) == "000")
                {
                    Console.WriteLine();
                    Console.WriteLine("Processing: " + URL);
                    sb.AppendLine();
                    sb.AppendLine("Processing: " + URL);
                }
                
                // Allowing 5 retries to pull same URL
                // I've seen this work with max of one retry.
                // The error here is usually a gateway timeout, which is corrected by just trying again.
                bool tryAgain = true;
                int maxRetry = 5;
                int retryCount = 1;
                
                while (tryAgain)
                {
                    try
                    {
                        using (WebClient client = new WebClient())
                        {
                            xmlDOC = client.DownloadString(URL);
                        }
                        if (retryCount > 1)
                        {
                            Console.WriteLine("Successful on Attempt #" + retryCount.ToString());
                            sb.AppendLine("Successful on Attempt #" + retryCount.ToString());
                        }
                        tryAgain = false;
                    }
                    catch (Exception e)
                    { 
                        Console.WriteLine("Load failed on " + URL);
                        Console.WriteLine("Exception: " + e.Message);
                        Console.WriteLine("Trying Again: " + retryCount.ToString() + " of " + maxRetry.ToString());

                        sb.AppendLine("Load failed on " + URL);
                        sb.AppendLine("Exception: " + e.Message);
                        sb.AppendLine("Trying Again: " + retryCount.ToString() + " of " + maxRetry.ToString());
                        
                        if (retryCount < maxRetry)
                        { retryCount++; }
                        else
                        { 
                            tryAgain = false; 
                        }

                    }
                }   

                //Remove Namespaces
                xmlDOC = xmlDOC.Replace("<ns1:", "<");
                xmlDOC = xmlDOC.Replace("</ns1:", "</");

                
            return xmlDOC;
        }

        public string xmlToProcess(string xmlDOC)
        {
             string MinXML="";
   
                // This will limit the entry XML to just <Feed><entry></entry><feed> format for easy processing
                // Also, if no entries then it will return an empty string ("") to be handled in main.
                string SearchFor = "<entry>";
                if (xmlDOC.Contains(SearchFor))
                {
                    MinXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
                    MinXML += "\r\n<feed>\r\n"; //CRLF before and after for viewing purposes

                    int Start = xmlDOC.IndexOf(SearchFor);
                    MinXML += xmlDOC.Substring(Start);

                }

                return MinXML;
        }
                
            

            
        

        public string NextURL(string xmlDOC)
        {
            //returning "" will indicate no more records and stop process
            string nextURL = "";

            // Find Next File in XMLDOC
            string SearchFor = "link rel=\"next\" type=\"text/html\" href=";
            
            
            if (xmlDOC.Contains(SearchFor))
            {
                int Start = xmlDOC.IndexOf(SearchFor);
                Start = Start + SearchFor.Length + 1;

                // Look for endQuote of URL reference
                SearchFor = ((char)34).ToString();  //looking for a double quote
                int End = xmlDOC.IndexOf(SearchFor, Start);
                nextURL = xmlDOC.Substring(Start, End - Start);
                
                //Clean up extra characters in URL
                //I don't know why this needs to be done but it won't run otherwise
                nextURL = nextURL.Replace("amp;", "");

            }


            return nextURL;
        }
    }
}



namespace SendEmail
{ 
    class SendEmail
    {
        public void Mail()
        {
            
            MailMessage mail = new MailMessage();
            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Host = "Your email IP";
            
            mail.From = new MailAddress("Your email address");
            //mail.To.Add(new MailAddress("Your Recipient email/group address"));
            mail.To.Add(new MailAddress("keith.langley@associates.hq.dhs.gov"));
            mail.Subject = "ATOM Complete";
            mail.Body = BuildHTMLBody();

            
            
            mail.IsBodyHtml = true;
            client.Send(mail);

        }

        public string BuildHTMLBody()
        {
            string body;

            body = "<b>ATOM Feed has been processed.";
            body += "<BR/><BR/>";
            body += "<i>ERA Staff</i></b>";

            return body;
        }

        //public List<string> GetEmailList
        //{ 
        //    List<String>( Emails = new List<string>();
        //    List<string> emails = NewLineHandling List<string>;
        //}
    }
}

namespace ProcessXML
{
    class Program
    {
        static void Main(string[] args)
        {

            //Taking out XSD validation
            //ValidateXML.Service.Validations validate = new ValidateXML.Service.Validations();
            //string isValidate = validate.ValidateXMLUsingXSD();
            //if (isValidate == string.Empty)
            //    isValidate = "Xml is well formed according to XSD.";
            //Console.WriteLine(isValidate);
            //Console.ReadLine();
                        
            
            //create log file via string builder
            StringBuilder sbMain = new StringBuilder();


            // Get ATOM from PullATOM Class

            Console.WriteLine(DateTime.Now.ToString());

            //Create a loop variable for Funding and Contracting Awards
            string[] Agencies = //{ "7001" };
                                {"7001","7003","7004","7008","7009","7012","7013","7014","7015","7022","7007","6950"};

            foreach (string Agency in Agencies)
            {
                int ctr = 1;

                while (ctr <= 2) // Loop thru twice.  First time is Agency_Code , 2nd time is Funding_Agency_ID
                {
                    //ActionCounter for Loop
                    int ActionCounter=0;

                    //set passing values to build 1st pull
                    string AwardOrIDV = "award" ;
                    string ContractingOrFunding = ctr == 1 ? "AGENCY_CODE" : "FUNDING_AGENCY_ID";

                    GetXML.PullAtom PA = new GetXML.PullAtom();

                    string xmlDOC = PA.AtomXML("",sbMain, AwardOrIDV, ContractingOrFunding, Agency);
                    if (xmlDOC == "")
                    {
                        sbMain.AppendLine("Failed to Fully load " + ContractingOrFunding + " = " + Agency + " Awards");
                        break;
                    }

                    string NextURL = PA.NextURL(xmlDOC);
                    string MinXML = PA.xmlToProcess(xmlDOC);
                    //Console.WriteLine(MinXML);

                    sbMain.AppendLine("Attmepting to Process : " + ContractingOrFunding + " = " + Agency + " Awards");

                    if (MinXML != "")
                    {
                        XDocument xml = XDocument.Parse(MinXML);
                        LINQandLoad.LINQ SQL = new LINQandLoad.LINQ();
                        ActionCounter = SQL.LINQ_Load(sbMain, xml, AwardOrIDV, ActionCounter);
                    }

                    // Loop thru process while NextURL is not Empty
                    while (NextURL != "")
                    {
                        xmlDOC = PA.AtomXML(NextURL,sbMain);
                        if (xmlDOC == "")
                        {
                            sbMain.AppendLine("Failed to Fully load an XML Document from Source" + ContractingOrFunding + " = " + Agency + " Awards");
                            break;
                        }
                        NextURL = PA.NextURL(xmlDOC);

                        MinXML = PA.xmlToProcess(xmlDOC);

                        if (MinXML != "")
                        {
                            XDocument xml = XDocument.Parse(MinXML);
                            LINQandLoad.LINQ SQL = new LINQandLoad.LINQ();
                            ActionCounter = SQL.LINQ_Load(sbMain, xml, AwardOrIDV, ActionCounter);
                        }
                        //Console.WriteLine(RecordsAdded.ToString());
                    }

                    //increase counter
                    ctr++;

                    //Provide total for log file
                    sbMain.AppendLine(ActionCounter.ToString() + " Awards Processed for " + Agency.ToString());
                    Console.WriteLine(ActionCounter.ToString() + " Awards Processed for " + Agency.ToString());

                    //Insert space in log
                    sbMain.AppendLine();
                }
            } //Close outer loop


            //Now Pull IDVs for All Agencies (The load script will force into correct buckets
            try
            {
                int ActionCounter = 0;

                string AwardOrIDV = "IDV";

                GetXML.PullAtom PA = new GetXML.PullAtom();

                string xmlDOC = PA.AtomXML("",sbMain, AwardOrIDV, null, null);
                if (xmlDOC == "")
                {
                    Console.WriteLine("Failed to Fully load");
                    //break;
                }

                sbMain.AppendLine("Attmepting to Process : All IDVs");

                string NextURL = PA.NextURL(xmlDOC);
                string MinXML = PA.xmlToProcess(xmlDOC);
                //Console.WriteLine(MinXML);


                if (MinXML != "")
                {
                    XDocument xml = XDocument.Parse(MinXML);
                    LINQandLoad.LINQ SQL = new LINQandLoad.LINQ();
                    ActionCounter = SQL.LINQ_Load(sbMain, xml, AwardOrIDV, ActionCounter);
                }

                // Loop thru process while NextURL is not Empty
                while (NextURL != "")
                {
                    xmlDOC = PA.AtomXML(NextURL,sbMain);
                    if (xmlDOC == "")
                    {
                        sbMain.AppendLine("Failed to Fully load an XML Document from Source");
                        break;
                    }
                    NextURL = PA.NextURL(xmlDOC);

                    MinXML = PA.xmlToProcess(xmlDOC);

                    if (MinXML != "")
                    {
                        XDocument xml = XDocument.Parse(MinXML);
                        LINQandLoad.LINQ SQL = new LINQandLoad.LINQ();
                        ActionCounter = SQL.LINQ_Load(sbMain, xml, AwardOrIDV, ActionCounter);
                    }

                    

                    //Console.WriteLine(RecordsAdded.ToString());
                }
                //Write Count for IDVs to log
                sbMain.AppendLine(ActionCounter.ToString() + " IDVs Processed");
                Console.WriteLine(ActionCounter.ToString() + " IDVs Processed");
            }
            catch (Exception e)
            {
                sbMain.Append("ATOM pull for IDVs failed with error: " + e.Message);
            }


            sbMain.AppendLine();
            sbMain.AppendLine("ATOM Pull is COMPLETE");

            Console.WriteLine(DateTime.Now.ToString()); 
            Console.WriteLine("ATOM Pull is COMPLETE");
            //Console.ReadLine();

            //Send email Completion to OCPO
            SendEmail.SendEmail SE = new SendEmail.SendEmail();
            SE.Mail();

            //Write sbMain to output
            string LocLogFile = @"C:\\ATOMLogFile " + DateTime.Now.ToString("yyyy-MM-dd") + ".txt";

            StreamWriter file = new StreamWriter(LocLogFile);
            file.WriteLine(sbMain.ToString());
            file.Close();
            //Console.ReadLine();
        }
 
   }
}


 namespace LINQandLoad
{
    class LINQ
    {
        public int LINQ_Load(StringBuilder sb,XDocument xml, string AwardOrIDV, int ActionCounter)
          {
            //return value
              //StringBuilder sb = new StringBuilder();

              #region LINQ

              // Logic for LINQ
            // for node values --> If node doesn't exist then return empty string ("")
            // for attributes --> if node exists, if it does look up attribute, else return empty string ("")


              var entries = from x in xml.Descendants(AwardOrIDV)
                             
                          select new
                        {   
                            version = (string) x.Attribute("version")
                            ,
                            A76Action = (string)x.Descendants("A76Action").FirstOrDefault()
                            ,
                            A76ActionDesc = (string)x.Descendants("A76Action").FirstOrDefault() != null ? (string)x.Descendants("A76Action").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            agencyID = (string)x.Descendants("agencyID").FirstOrDefault()
                            ,
                            agencyName = (string)x.Descendants("agencyID").FirstOrDefault() != null ? (string)x.Descendants("agencyID").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            alternateAdvertising = (string)x.Descendants("alternateAdvertising").FirstOrDefault()
                            ,
                            annualRevenue = (string)x.Descendants("annualRevenue").FirstOrDefault()
                            ,
                            baseAndAllOptionsValue = (string)x.Descendants("baseAndAllOptionsValue").FirstOrDefault()
                            ,
                            baseAndExercisedOptionsValue = (string)x.Descendants("baseAndExercisedOptionsValue").FirstOrDefault()
                            ,
                            CCRException = (string)x.Descendants("CCRException").FirstOrDefault()
                            ,
                            CCRExceptionDesc = (string)x.Descendants("CCRException").FirstOrDefault() != null ? (string)x.Descendants("CCRException").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            city = (string)x.Descendants("city").FirstOrDefault()
                            ,
                            claimantProgramCode = (string)x.Descendants("claimantProgramCode").FirstOrDefault()
                            ,
                            claimantProgramDesc = (string)x.Descendants("claimantProgramCode").FirstOrDefault() != null ? (string)x.Descendants("claimantProgramCode").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            ClingerCohenAct = (string)x.Descendants("ClingerCohenAct").FirstOrDefault()
                            ,
                            ClingerCohenActDesc = (string)x.Descendants("ClingerCohenAct").FirstOrDefault() != null ? (string)x.Descendants("ClingerCohenAct").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            commercialItemAcquisitionProcedures = (string)x.Descendants("commercialItemAcquisitionProcedures").FirstOrDefault()
                            ,
                            commercialItemAcquisitionProceduresDesc = (string)x.Descendants("commercialItemAcquisitionProcedures").FirstOrDefault() != null ? (string)x.Descendants("commercialItemAcquisitionProcedures").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            commercialItemTestProgram = (string)x.Descendants("commercialItemTestProgram").FirstOrDefault()
                            ,
                            commercialItemTestProgramDesc = (string)x.Descendants("commercialItemTestProgram").FirstOrDefault() != null ? (string)x.Descendants("commercialItemTestProgram").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            competitveProcedures = (string)x.Descendants("competitveProcedures").FirstOrDefault()
                            ,
                            congressionalDistrictCode = (string)x.Descendants("congressionalDistrictCode").FirstOrDefault()
                            ,
                            consolidatedContract = (string)x.Descendants("consolidatedContract").FirstOrDefault()
                            ,
                            consolidatedContractDesc = (string)x.Descendants("consolidatedContract").FirstOrDefault() != null ? (string)x.Descendants("consolidatedContract").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contingencyHumanitarianPeacekeepingOperation = (string)x.Descendants("contingencyHumanitarianPeacekeepingOperation").FirstOrDefault()
                            ,
                            contingencyHumanitarianPeacekeepingOperationDesc = (string)x.Descendants("contingencyHumanitarianPeacekeepingOperation").FirstOrDefault() != null ? (string)x.Descendants("contingencyHumanitarianPeacekeepingOperation").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contractActionType = (string)x.Descendants("contractActionType").FirstOrDefault()
                            ,
                            contractActionTypeDesc = (string)x.Descendants("contractActionType").FirstOrDefault() != null ? (string)x.Descendants("contractActionType").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contractActionTypePart8Or13 = (string)x.Descendants("contractActionType").FirstOrDefault() != null ? (string)x.Descendants("contractActionType").FirstOrDefault().Attribute("part8OrPart13") : (string)""
                            ,
                            contractBundling = (string)x.Descendants("contractBundling").FirstOrDefault()
                            ,
                            contractBundlingDesc = (string)x.Descendants("contractBundling").FirstOrDefault() != null ? (string)x.Descendants("contractBundling").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contractFinancing = (string)x.Descendants("contractFinancing").FirstOrDefault()
                            ,
                            contractFinancingDesc = (string)x.Descendants("contractFinancing").FirstOrDefault() != null ? (string)x.Descendants("contractFinancing").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contractingOfficeAgencyID = (string)x.Descendants("contractingOfficeAgencyID").FirstOrDefault()
                            ,
                            contractingOfficeAgencyName = (string)x.Descendants("contractingOfficeAgencyID").FirstOrDefault() != null ? (string)x.Descendants("contractingOfficeAgencyID").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            contractingOfficeID = (string)x.Descendants("contractingOfficeID").FirstOrDefault()
                            ,
                            contractingOfficeName = (string)x.Descendants("contractingOfficeID").FirstOrDefault() != null ? (string)x.Descendants("contractingOfficeID").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            contractingOfficerBusinessSizeDetermination = (string)x.Descendants("contractingOfficerBusinessSizeDetermination").FirstOrDefault()
                            ,
                            contractingOfficerBusinessSizeDeterminationDesc = (string)x.Descendants("contractingOfficerBusinessSizeDetermination").FirstOrDefault() != null ? (string)x.Descendants("contractingOfficerBusinessSizeDetermination").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            contractorName = (string)x.Descendants("contractorName").FirstOrDefault() != null 
                            ,
                            costAccountingStandardsClause = (string)x.Descendants("costAccountingStandardsClause").FirstOrDefault()
                            ,
                            costAccountingStandardsClauseDesc = (string)x.Descendants("costAccountingStandardsClause").FirstOrDefault() != null ? (string)x.Descendants("costAccountingStandardsClause").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            costOrPricingData = (string)x.Descendants("costOrPricingData").FirstOrDefault()
                            ,
                            costOrPricingDataDesc = (string)x.Descendants("costOrPricingData").FirstOrDefault() != null ? (string)x.Descendants("costOrPricingData").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            countryCode = (string)x.Descendants("countryCode").FirstOrDefault()
                            ,
                            countryName = (string)x.Descendants("countryCode").FirstOrDefault() != null ? (string)x.Descendants("countryCode").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            countryOfIncorporation = (string)x.Descendants("countryOfIncorporation").FirstOrDefault()
                            ,
                            countryOfIncorporationName = (string)x.Descendants("countryOfIncorporation").FirstOrDefault() != null ? (string)x.Descendants("countryOfIncorporation").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            countryOfOrigin = (string)x.Descendants("countryOfOrigin").FirstOrDefault()
                            ,
                            countryOfOriginName = (string)x.Descendants("countryOfOrigin").FirstOrDefault() != null ? (string)x.Descendants("countryOfOrigin").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            createdBy = (string)x.Descendants("createdBy").FirstOrDefault()
                            ,
                            createdDate = (string)x.Descendants("createdDate").FirstOrDefault()
                            ,
                            currentCompletionDate = (string)x.Descendants("currentCompletionDate").FirstOrDefault()
                            ,
                            DavisBaconAct = (string)x.Descendants("DavisBaconAct").FirstOrDefault()
                            ,
                            DavisBaconActDesc = (string)x.Descendants("DavisBaconAct").FirstOrDefault() != null ? (string)x.Descendants("DavisBaconAct").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            departmentID = (string)x.Descendants("departmentID").FirstOrDefault()
                            ,
                            descriptionOfContractRequirement = (string)x.Descendants("descriptionOfContractRequirement").FirstOrDefault()
                            ,
                            divisionName = (string)x.Descendants("divisionName").FirstOrDefault()
                            ,
                            divisionNumberOrOfficeCode = (string)x.Descendants("divisionNumberOrOfficeCode").FirstOrDefault()
                            ,
                            domesticParentDUNSNumber = (string)x.Descendants("domesticParentDUNSNumber").FirstOrDefault()
                            ,
                            domesticParentDUNSName = (string) x.Descendants("domesticParentDUNSName").FirstOrDefault()
                            ,
                            DUNSNumber = (string)x.Descendants("DUNSNumber").FirstOrDefault()
                            ,
                            economyAct = (string)x.Descendants("economyAct").FirstOrDefault()
                            ,
                            effectiveDate = (string)x.Descendants("effectiveDate").FirstOrDefault()
                            ,
                            emailAddress = (string)x.Descendants("emailAddress").FirstOrDefault()
                            ,
                            evaluatedPreference = (string)x.Descendants("evaluatedPreference").FirstOrDefault()
                            ,
                            evaluatedPreferenceDesc = (string)x.Descendants("evaluatedPreference").FirstOrDefault() != null ? (string)x.Descendants("evaluatedPreference").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            extentCompeted = (string)x.Descendants("extentCompeted").FirstOrDefault()
                            ,
                            extentCompetedDesc = (string)x.Descendants("extentCompeted").FirstOrDefault() != null ? (string)x.Descendants("extentCompeted").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            extractSource = (string)x.Descendants("extractSource").FirstOrDefault()
                            ,
                            faxNo = (string)x.Descendants("faxNo").FirstOrDefault()
                            ,
                            fedBizOpps = (string)x.Descendants("fedBizOpps").FirstOrDefault()
                            ,
                            fedBizOppsDesc = (string)x.Descendants("fedBizOpps").FirstOrDefault() != null ? (string)x.Descendants("fedBizOpps").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            feePaidForUseOfService = (string)x.Descendants("feePaidForUseOfService").FirstOrDefault()
                            ,
                            foreignFunding = (string)x.Descendants("foreignFunding").FirstOrDefault()
                            ,
                            foreignFundingDesc = (string)x.Descendants("foreignFunding").FirstOrDefault() != null ? (string)x.Descendants("foreignFunding").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            fundingRequestingAgencyID = (string)x.Descendants("fundingRequestingAgencyID").FirstOrDefault()
                            ,
                            fundingRequestingAgencyName = (string)x.Descendants("fundingRequestingAgencyID").FirstOrDefault() != null ? (string)x.Descendants("fundingRequestingAgencyID").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            fundingRequestingOfficeID = (string)x.Descendants("fundingRequestingOfficeID").FirstOrDefault()
                            ,
                            fundingRequestingOfficeName = (string)x.Descendants("fundingRequestingOfficeID").FirstOrDefault() != null ? (string)x.Descendants("fundingRequestingOfficeID").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            GFEGFP = (string)x.Descendants("GFEGFP").FirstOrDefault()
                            ,
                            GFEGFPDesc = (string)x.Descendants("GFEGFP").FirstOrDefault() != null ? (string)x.Descendants("GFEGFP").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            globalParentDUNSNumber = (string)x.Descendants("globalParentDUNSNumber").FirstOrDefault()
                            ,
                            globalParentDUNSName = (string)x.Descendants("globalParentDUNSName").FirstOrDefault()
                            ,
                            informationTechnologyCommercialItemCategory = (string)x.Descendants("informationTechnologyCommercialItemCategory").FirstOrDefault()
                            ,
                            informationTechnologyCommercialItemCategoryDesc = (string)x.Descendants("informationTechnologyCommercialItemCategory").FirstOrDefault() != null ? (string)x.Descendants("informationTechnologyCommercialItemCategory").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            interagencyContractingAuthority = (string)x.Descendants("interagencyContractingAuthority").FirstOrDefault()
                            ,
                            interagencyContractingAuthorityDesc = (string)x.Descendants("interagencyContractingAuthority").FirstOrDefault() != null ? (string)x.Descendants("interagencyContractingAuthority").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            is1862LandGrantCollege = (string)x.Descendants("is1862LandGrantCollege").FirstOrDefault()
                            ,
                            is1890LandGrantCollege = (string)x.Descendants("is1890LandGrantCollege").FirstOrDefault()
                            ,
                            is1994LandGrantCollege = (string)x.Descendants("is1994LandGrantCollege").FirstOrDefault()
                            ,
                            isAirportAuthority = (string)x.Descendants("isAirportAuthority").FirstOrDefault()
                            ,
                            isAlaskanNativeOwnedCorporationOrFirm = (string)x.Descendants("isAlaskanNativeOwnedCorporationOrFirm").FirstOrDefault()
                            ,
                            isAlaskanNativeServicingInstitution = (string)x.Descendants("isAlaskanNativeServicingInstitution").FirstOrDefault()
                            ,
                            isAmericanIndianOwned = (string)x.Descendants("isAmericanIndianOwned").FirstOrDefault()
                            ,
                            isArchitectureAndEngineering = (string)x.Descendants("isArchitectureAndEngineering").FirstOrDefault()
                            ,
                            isAsianPacificAmericanOwnedBusiness = (string)x.Descendants("isAsianPacificAmericanOwnedBusiness").FirstOrDefault()
                            ,
                            isBlackAmericanOwnedBusiness = (string)x.Descendants("isBlackAmericanOwnedBusiness").FirstOrDefault()
                            ,
                            isCityLocalGovernment = (string)x.Descendants("isCityLocalGovernment").FirstOrDefault()
                            ,
                            isCommunityDevelopedCorporationOwnedFirm = (string)x.Descendants("isCommunityDevelopedCorporationOwnedFirm").FirstOrDefault()
                            ,
                            isCommunityDevelopmentCorporation = (string)x.Descendants("isCommunityDevelopmentCorporation").FirstOrDefault()
                            ,
                            isConstructionFirm = (string)x.Descendants("isConstructionFirm").FirstOrDefault()
                            ,
                            isCorporateEntityNotTaxExempt = (string)x.Descendants("isCorporateEntityNotTaxExempt").FirstOrDefault()
                            ,
                            isCorporateEntityTaxExempt = (string)x.Descendants("isCorporateEntityTaxExempt").FirstOrDefault()
                            ,
                            isCouncilOfGovernments = (string)x.Descendants("isCouncilOfGovernments").FirstOrDefault()
                            ,
                            isCountyLocalGovernment = (string)x.Descendants("isCountyLocalGovernment").FirstOrDefault()
                            ,
                            isDomesticShelter = (string)x.Descendants("isDomesticShelter").FirstOrDefault()
                            ,
                            isDOTCertifiedDisadvantagedBusinessEnterprise = (string)x.Descendants("isDOTCertifiedDisadvantagedBusinessEnterprise").FirstOrDefault()
                            ,
                            isEducationalInstitution = (string)x.Descendants("isEducationalInstitution").FirstOrDefault()
                            ,
                            isFederalGovernment = (string)x.Descendants("isFederalGovernment").FirstOrDefault()
                            ,
                            isFederalGovernmentAgency = (string)x.Descendants("isFederalGovernmentAgency").FirstOrDefault()
                            ,
                            isFederallyFundedResearchAndDevelopmentCorp = (string)x.Descendants("isFederallyFundedResearchAndDevelopmentCorp").FirstOrDefault()
                            ,
                            isForeignGovernment = (string)x.Descendants("isForeignGovernment").FirstOrDefault()
                            ,
                            isForeignOwnedAndLocated = (string)x.Descendants("isForeignOwnedAndLocated").FirstOrDefault()
                            ,
                            isForProfitOrganization = (string)x.Descendants("isForProfitOrganization").FirstOrDefault()
                            ,
                            isFoundation = (string)x.Descendants("isFoundation").FirstOrDefault()
                            ,
                            isHispanicAmericanOwnedBusiness = (string)x.Descendants("isHispanicAmericanOwnedBusiness").FirstOrDefault()
                            ,
                            isHispanicServicingInstitution = (string)x.Descendants("isHispanicServicingInstitution").FirstOrDefault()
                            ,
                            isHistoricallyBlackCollegeOrUniverity = (string)x.Descendants("isHistoricallyBlackCollegeOrUniverity").FirstOrDefault()
                            ,
                            isHospital = (string)x.Descendants("isHospital").FirstOrDefault()
                            ,
                            isHousingAuthoritiesPublicOrTribal = (string)x.Descendants("isHousingAuthoritiesPublicOrTribal").FirstOrDefault()
                            ,
                            isIndianTribe = (string)x.Descendants("isIndianTribe").FirstOrDefault()
                            ,
                            isInterMunicipalLocalGovernment = (string)x.Descendants("isInterMunicipalLocalGovernment").FirstOrDefault()
                            ,
                            isInternationalOrganization = (string)x.Descendants("isInternationalOrganization").FirstOrDefault()
                            ,
                            isInterstateEntity = (string)x.Descendants("isInterstateEntity").FirstOrDefault()
                            ,
                            isLaborSurplusAreaFirm = (string)x.Descendants("isLaborSurplusAreaFirm").FirstOrDefault()
                            ,
                            isLimitedLiabilityCorporation = (string)x.Descendants("isLimitedLiabilityCorporation").FirstOrDefault()
                            ,
                            isLocalGovernment = (string)x.Descendants("isLocalGovernment").FirstOrDefault()
                            ,
                            isLocalGovernmentOwned = (string)x.Descendants("isLocalGovernmentOwned").FirstOrDefault()
                            ,
                            isManufacturerOfGoods = (string)x.Descendants("isManufacturerOfGoods").FirstOrDefault()
                            ,
                            isMinorityInstitution = (string)x.Descendants("isMinorityInstitution").FirstOrDefault()
                            ,
                            isMinorityOwned = (string)x.Descendants("isMinorityOwned").FirstOrDefault()
                            ,
                            isMunicipalityLocalGovernment = (string)x.Descendants("isMunicipalityLocalGovernment").FirstOrDefault()
                            ,
                            isNativeAmericanOwnedBusiness = (string)x.Descendants("isNativeAmericanOwnedBusiness").FirstOrDefault()
                            ,
                            isNativeHawaiianOwnedOrganizationOrFirm = (string)x.Descendants("isNativeHawaiianOwnedOrganizationOrFirm").FirstOrDefault()
                            ,
                            isNativeHawaiianServicingInstitution = (string)x.Descendants("isNativeHawaiianServicingInstitution").FirstOrDefault()
                            ,
                            isNonprofitOrganization = (string)x.Descendants("isNonprofitOrganization").FirstOrDefault()
                            ,
                            isOtherBusinessOrOrganization = (string)x.Descendants("isOtherBusinessOrOrganization").FirstOrDefault()
                            ,
                            isOtherMinorityOwned = (string)x.Descendants("isOtherMinorityOwned").FirstOrDefault()
                            ,
                            isOtherNotForProfitOrganization = (string)x.Descendants("isOtherNotForProfitOrganization").FirstOrDefault()
                            ,
                            isPartnershipOrLimitedLiabilityPartnership = (string)x.Descendants("isPartnershipOrLimitedLiabilityPartnership").FirstOrDefault()
                            ,
                            isPlanningCommission = (string)x.Descendants("isPlanningCommission").FirstOrDefault()
                            ,
                            isPortAuthority = (string)x.Descendants("isPortAuthority").FirstOrDefault()
                            ,
                            isPrivateUniversityOrCollege = (string)x.Descendants("isPrivateUniversityOrCollege").FirstOrDefault()
                            ,
                            isResearchAndDevelopment = (string)x.Descendants("isResearchAndDevelopment").FirstOrDefault()
                            ,
                            isSBACertified8AJointVenture = (string)x.Descendants("isSBACertified8AJointVenture").FirstOrDefault()
                            ,
                            isSBACertified8AProgramParticipant = (string)x.Descendants("isSBACertified8AProgramParticipant").FirstOrDefault()
                            ,
                            isSBACertifiedHUBZone = (string)x.Descendants("isSBACertifiedHUBZone").FirstOrDefault()
                            ,
                            isSBACertifiedSmallDisadvantagedBusiness = (string)x.Descendants("isSBACertifiedSmallDisadvantagedBusiness").FirstOrDefault()
                            ,
                            isSchoolDistrictLocalGovernment = (string)x.Descendants("isSchoolDistrictLocalGovernment").FirstOrDefault()
                            ,
                            isSchoolOfForestry = (string)x.Descendants("isSchoolOfForestry").FirstOrDefault()
                            ,
                            isSelfCertifiedSmallDisadvantagedBusiness = (string)x.Descendants("isSelfCertifiedSmallDisadvantagedBusiness").FirstOrDefault()
                            ,
                            isServiceProvider = (string)x.Descendants("isServiceProvider").FirstOrDefault()
                            ,
                            isServiceRelatedDisabledVeteranOwnedBusiness = (string)x.Descendants("isServiceRelatedDisabledVeteranOwnedBusiness").FirstOrDefault()
                            ,
                            isShelteredWorkshop = (string)x.Descendants("isShelteredWorkshop").FirstOrDefault()
                            ,
                            isSmallAgriculturalCooperative = (string)x.Descendants("isSmallAgriculturalCooperative").FirstOrDefault()
                            ,
                            isSmallBusiness = (string)x.Descendants("isSmallBusiness").FirstOrDefault()
                            ,
                            isSoleProprietorship = (string)x.Descendants("isSoleProprietorship").FirstOrDefault()
                            ,
                            isStateControlledInstituationofHigherLearning = (string)x.Descendants("isStateControlledInstituationofHigherLearning").FirstOrDefault()
                            ,
                            isStateGovernment = (string)x.Descendants("isStateGovernment").FirstOrDefault()
                            ,
                            isSubchapterSCorporation = (string)x.Descendants("isSubchapterSCorporation").FirstOrDefault()
                            ,
                            isSubContinentAsianAmericanOwnedBusiness = (string)x.Descendants("isSubContinentAsianAmericanOwnedBusiness").FirstOrDefault()
                            ,
                            isTownshipLocalGovernment = (string)x.Descendants("isTownshipLocalGovernment").FirstOrDefault()
                            ,
                            isTransitAuthority = (string)x.Descendants("isTransitAuthority").FirstOrDefault()
                            ,
                            isTribalCollege = (string)x.Descendants("isTribalCollege").FirstOrDefault()
                            ,
                            isTribalGovernment = (string)x.Descendants("isTribalGovernment").FirstOrDefault()
                            ,
                            isTriballyOwnedFirm = (string)x.Descendants("isTriballyOwnedFirm").FirstOrDefault()
                            ,
                            isUSGovernmentEntity = (string)x.Descendants("isUSGovernmentEntity").FirstOrDefault()
                            ,
                            isVerySmallBusiness = (string)x.Descendants("isVerySmallBusiness").FirstOrDefault()
                            ,
                            isVeteranOwned = (string)x.Descendants("isVeteranOwned").FirstOrDefault()
                            ,
                            isVeterinaryCollege = (string)x.Descendants("isVeterinaryCollege").FirstOrDefault()
                            ,
                            isVeterinaryHospital = (string)x.Descendants("isVeterinaryHospital").FirstOrDefault()
                            ,
                            isWomenOwned = (string)x.Descendants("isWomenOwned").FirstOrDefault()
                            ,
                            lastDateToOrder = (string)x.Descendants("lastDateToOrder").FirstOrDefault()
                            ,
                            lastModifiedBy = (string)x.Descendants("lastModifiedBy").FirstOrDefault()
                            ,
                            lastModifiedDate = (DateTime)x.Descendants("lastModifiedDate").FirstOrDefault()
                            ,
                            localAreaSetAside = (string)x.Descendants("localAreaSetAside").FirstOrDefault()
                            ,
                            localAreaSetAsideDesc = (string)x.Descendants("localAreaSetAside").FirstOrDefault() != null ? (string)x.Descendants("localAreaSetAside").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            majorProgramCode = (string)x.Descendants("majorProgramCode").FirstOrDefault()
                            ,
                            manufacturingOrganizationType = (string)x.Descendants("manufacturingOrganizationType").FirstOrDefault()
                            ,
                            manufacturingOrganizationTypeDesc = (string)x.Descendants("manufacturingOrganizationType").FirstOrDefault() != null ? (string)x.Descendants("manufacturingOrganizationType").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            maximumOrderLimit = (string)x.Descendants("maximumOrderLimit").FirstOrDefault()
                            ,
                            modNumber = (string)x.Descendants("modNumber").FirstOrDefault()
                            ,
                            multipleOrSingleAwardIDC = (string)x.Descendants("multipleOrSingleAwardIDC").FirstOrDefault()
                            ,
                            multipleOrSingleAwardIDCDesc = (string)x.Descendants("multipleOrSingleAwardIDC").FirstOrDefault() != null ? (string)x.Descendants("multipleOrSingleAwardIDC").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            multiYearContract = (string)x.Descendants("multiYearContract").FirstOrDefault()
                            ,
                            multiYearContractDesc = (string)x.Descendants("multiYearContract").FirstOrDefault() != null ? (string)x.Descendants("multiYearContract").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            nationalInterestActionCode = (string)x.Descendants("nationalInterestActionCode").FirstOrDefault()
                            ,
                            nationalInterestActionDesc = (string)x.Descendants("nationalInterestActionCode").FirstOrDefault() != null ? (string)x.Descendants("nationalInterestActionCode").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            numberOfActions = (string)x.Descendants("numberOfActions").FirstOrDefault()
                            ,
                            numberOfEmployees = (string)x.Descendants("numberOfEmployees").FirstOrDefault()
                            ,
                            numberOfOffersReceived = (string)x.Descendants("numberOfOffersReceived").FirstOrDefault()
                            ,
                            obligatedAmount = (string)x.Descendants("obligatedAmount").FirstOrDefault()
                            ,
                            orderingProcedure = (string)x.Descendants("orderingProcedure").FirstOrDefault()
                            ,
                            organizationalType = (string)x.Descendants("organizationalType").FirstOrDefault()
                            ,
                            otherStatutoryAuthority = (string)x.Descendants("otherStatutoryAuthority").FirstOrDefault()
                            ,
                            parentDUNSNumber = (string)x.Descendants("parentDUNSNumber").FirstOrDefault()
                            ,
                            parentDUNSName = (string)x.Descendants("parentDUNSName").FirstOrDefault()
                            ,
                            performanceBasedServiceContract = (string)x.Descendants("performanceBasedServiceContract").FirstOrDefault()
                            ,
                            performanceBasedServiceContractDesc = (string)x.Descendants("performanceBasedServiceContract").FirstOrDefault() != null ? (string)x.Descendants("performanceBasedServiceContract").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            phoneNo = (string)x.Descendants("phoneNo").FirstOrDefault()
                            ,
                            PIID = (string)x.Descendants("PIID").FirstOrDefault()
                            ,
                            placeOfManufacture = (string)x.Descendants("placeOfManufacture").FirstOrDefault()
                            ,
                            placeOfManufactureDesc = (string)x.Descendants("placeOfManufacture").FirstOrDefault() != null ? (string)x.Descendants("placeOfManufacture").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            placeOfPerformanceCongressionalDistrict = (string)x.Descendants("placeOfPerformanceCongressionalDistrict").FirstOrDefault()
                            ,
                            placeOfPerformanceZIPCode = (string)x.Descendants("placeOfPerformanceZIPCode").FirstOrDefault()
                            ,
                            placeOfPerformanceZIPCodeCity = (string)x.Descendants("placeOfPerformanceZIPCodeCity").FirstOrDefault()
                            ,
                            placeOfPerformanceZIPCodeCountry = (string)x.Descendants("placeOfPerformanceZIPCodeCountry").FirstOrDefault()
                            ,
                            preAwardSynopsisRequirement = (string)x.Descendants("preAwardSynopsisRequirement").FirstOrDefault()
                            ,
                            priceEvaluationPercentDifference = (string)x.Descendants("priceEvaluationPercentDifference").FirstOrDefault()
                            ,
                            principalNAICSCode = (string)x.Descendants("principalNAICSCode").FirstOrDefault()
                            ,
                            principalNAICSDesc = (string)x.Descendants("principalNAICSCode").FirstOrDefault() != null ? (string)x.Descendants("principalNAICSCode").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            principalPlaceOfPerformanceCountryCode = (string)x.Descendants("placeOfPerformance").Descendants("countryCode").FirstOrDefault()
                            ,
                            principalPlaceOfPerformanceCountryName = (string)x.Descendants("placeOfPerformance").Descendants("countryCode").FirstOrDefault() != null ? (string)x.Descendants("placeOfPerformance").Descendants("countryCode").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            principalPlaceOfPerformanceLocationCode = (string)x.Descendants("locationCode").FirstOrDefault()
                            ,
                            principalPlaceOfPerformanceStateCode = (string)x.Descendants("stateCode").FirstOrDefault()
                            ,
                            principalPlaceOfPerformanceStateName = (string)x.Descendants("stateCode").FirstOrDefault() != null ? (string)x.Descendants("stateCode").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            productOrServiceCode = (string)x.Descendants("productOrServiceCode").FirstOrDefault()
                            ,
                            productOrServiceDesc = (string)x.Descendants("productOrServiceCode").FirstOrDefault() != null ? (string)x.Descendants("productOrServiceCode").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            programAcronym = (string)x.Descendants("programAcronym").FirstOrDefault()
                            ,
                            province = (string)x.Descendants("province").FirstOrDefault()
                            ,
                            purchaseCardAsPaymentMethod = (string)x.Descendants("purchaseCardAsPaymentMethod").FirstOrDefault()
                            ,
                            purchaseCardAsPaymentMethodDesc = (string)x.Descendants("purchaseCardAsPaymentMethod").FirstOrDefault() != null ? (string)x.Descendants("purchaseCardAsPaymentMethod").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            purchaseReason = (string)x.Descendants("purchaseReason").FirstOrDefault()
                            ,
                            reasonForModification = (string)x.Descendants("reasonForModification").FirstOrDefault()
                            ,
                            reasonForModificationDesc = (string)x.Descendants("reasonForModification").FirstOrDefault() != null ? (string)x.Descendants("reasonForModification").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            reasonNotAwardedToSmallBusiness = (string)x.Descendants("reasonNotAwardedToSmallBusiness").FirstOrDefault()
                            ,
                            reasonNotAwardedToSmallDisadvantagedBusiness = (string)x.Descendants("reasonNotAwardedToSmallDisadvantagedBusiness").FirstOrDefault()
                            ,
                            reasonNotCompeted = (string)x.Descendants("reasonNotCompeted").FirstOrDefault()
                            ,
                            reasonNotCompetedDesc = (string)x.Descendants("reasonNotCompeted").FirstOrDefault() != null ? (string)x.Descendants("reasonNotCompeted").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            receivesContracts = (string)x.Descendants("receivesContracts").FirstOrDefault()
                            ,
                            receivesContractsAndGrants = (string)x.Descendants("receivesContractsAndGrants").FirstOrDefault()
                            ,
                            receivesGrants = (string)x.Descendants("receivesGrants").FirstOrDefault()
                            ,
                            recoveredMaterialClauses = (string)x.Descendants("recoveredMaterialClauses").FirstOrDefault()
                            ,
                            recoveredMaterialClausesDesc = (string)x.Descendants("recoveredMaterialClauses").FirstOrDefault() != null ? (string)x.Descendants("recoveredMaterialClauses").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            refIDVIDAgencyID = (string)x.Descendants("referencedIDVID").FirstOrDefault() != null ?
                                                    (string)x.Descendants("referencedIDVID").FirstOrDefault().Descendants("agencyID").FirstOrDefault()
                                                    : (string)null
                            ,
                            refIDVIDAgencyName = (string)x.Descendants("referencedIDVID").FirstOrDefault() != null
                                                    ? (string)x.Descendants("referencedIDVID").FirstOrDefault().Descendants("agencyID").FirstOrDefault().Attribute("name")
                                                        : (string)null
                                                    
                            ,
                            refIDVIDModNumber = (string)x.Descendants("referencedIDVID").FirstOrDefault() != null
                                                    ? (string)x.Descendants("referencedIDVID").FirstOrDefault().Descendants("modNumber").FirstOrDefault()
                                                    : (string)null
                            ,
                            refIDVIDPIID = (string)x.Descendants("referencedIDVID").FirstOrDefault() != null 
                                                    ? (string)x.Descendants("referencedIDVID").FirstOrDefault().Descendants("PIID").FirstOrDefault()
                                                    : (string)null
                            ,
                            registrationDate = (string)x.Descendants("registrationDate").FirstOrDefault()
                            ,
                            renewalDate = (string)x.Descendants("renewalDate").FirstOrDefault()
                            ,
                            research = (string)x.Descendants("research").FirstOrDefault()
                            ,
                            researchDesc = (string)x.Descendants("research").FirstOrDefault() != null ? (string)x.Descendants("research").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            seaTransportation = (string)x.Descendants("seaTransportation").FirstOrDefault()
                            ,
                            seaTransportationDesc = (string)x.Descendants("seaTransportation").FirstOrDefault() != null ? (string)x.Descendants("seaTransportation").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            serviceContractAct = (string)x.Descendants("serviceContractAct").FirstOrDefault()
                            ,
                            serviceContractActDesc = (string)x.Descendants("serviceContractAct").FirstOrDefault() != null ? (string)x.Descendants("serviceContractAct").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            signedDate = (string)x.Descendants("signedDate").FirstOrDefault()
                            ,
                            smallBusinessCompetitivenessDemonstrationProgram = (string)x.Descendants("smallBusinessCompetitivenessDemonstrationProgram").FirstOrDefault()
                            ,
                            solicitationID = (string)x.Descendants("solicitationID").FirstOrDefault()
                            ,
                            solicitationProcedures = (string)x.Descendants("solicitationProcedures").FirstOrDefault()
                            ,
                            solicitationProceduresDesc = (string)x.Descendants("solicitationProcedures").FirstOrDefault() != null ? (string)x.Descendants("solicitationProcedures").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            state = (string)x.Descendants("state").FirstOrDefault()
                            ,
                            stateName = (string)x.Descendants("state").FirstOrDefault() != null ? (string)x.Descendants("state").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            stateOfIncorporation = (string)x.Descendants("stateOfIncorporation").FirstOrDefault()
                            ,
                            stateOfIncorporationName = (string)x.Descendants("stateOfIncorporation").FirstOrDefault() != null ? (string)x.Descendants("stateOfIncorporation").FirstOrDefault().Attribute("name") : (string)null
                            ,
                            status = (string)x.Descendants("status").FirstOrDefault()
                            ,
                            statusDesc = (string)x.Descendants("status").FirstOrDefault() != null ? (string)x.Descendants("status").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            statutoryExceptionToFairOpportunity = (string)x.Descendants("statutoryExceptionToFairOpportunity").FirstOrDefault()
                            ,
                            statutoryExceptionToFairOpportunityDesc = (string)x.Descendants("statutoryExceptionToFairOpportunity").FirstOrDefault() != null ? (string)x.Descendants("statutoryExceptionToFairOpportunity").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            streetAddress = (string)x.Descendants("streetAddress").FirstOrDefault()
                            ,
                            streetAddress2 = (string)x.Descendants("streetAddress2").FirstOrDefault()
                            ,
                            streetAddress3 = (string)x.Descendants("streetAddress3").FirstOrDefault()
                            ,
                            subcontractPlan = (string)x.Descendants("subcontractPlan").FirstOrDefault()
                            ,
                            subcontractPlanDesc = (string)x.Descendants("subcontractPlan").FirstOrDefault() != null ? (string)x.Descendants("subcontractPlan").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            synopsisWaiverException = (string)x.Descendants("synopsisWaiverException").FirstOrDefault()
                            ,
                            synopsisWaiverExceptionSpecified = (string)x.Descendants("synopsisWaiverExceptionSpecified").FirstOrDefault()
                            ,
                            systemEquipmentCode = (string)x.Descendants("systemEquipmentCode").FirstOrDefault()
                            ,
                            systemEquipmentDesc = (string)x.Descendants("systemEquipmentCode").FirstOrDefault() != null ? (string)x.Descendants("systemEquipmentCode").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            transactionNumber = (string)x.Descendants("transactionNumber").FirstOrDefault()
                            ,
                            transactionSource = (string)x.Descendants("transactionSource").FirstOrDefault()
                            ,
                            transactionSourceDesc = (string)x.Descendants("transactionSource").FirstOrDefault() != null ? (string)x.Descendants("transactionSource").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            treasuryagencyIdentifier = (string)x.Descendants("agencyIdentifier").FirstOrDefault() 
                            ,
                            treasuryagencyIdentifierName = (string)x.Descendants("agencyIdentifier").FirstOrDefault() != null ?
                                                                (string)x.Descendants("agencyIdentifier").FirstOrDefault().Attribute("name")
                                                                    : (string)null
                                                                
                            ,
                            treasuryallocationTransferAgencyIdentifier = (string)x.Descendants("treasuryallocationTransferAgencyIdentifier").FirstOrDefault()
                            ,
                            treasuryavailabilityTypeCode = (string)x.Descendants("treasuryavailabilityTypeCode").FirstOrDefault()
                            ,
                            treasuryavailabilityTypeDescription = (string)x.Descendants("treasuryavailabilityTypeDescription").FirstOrDefault()
                            ,
                            treasurybeginningPeriodOfAvailability = (string)x.Descendants("treasurybeginningPeriodOfAvailability").FirstOrDefault()
                            ,
                            treasuryendingPeriodOfAvailability = (string)x.Descendants("treasuryendingPeriodOfAvailability").FirstOrDefault()
                            ,
                            treasuryinitiative = (string)x.Descendants("treasuryinitiative").FirstOrDefault()
                            ,
                            treasuryinitiativeDescription = (string)x.Descendants("treasuryinitiativeDescription").FirstOrDefault()
                            ,
                            treasurymainAccountCode = (string)x.Descendants("mainAccountCode").FirstOrDefault()
                            ,
                            treasuryobligatedAmount = (string)x.Descendants("treasuryobligatedAmount").FirstOrDefault()
                            ,
                            treasuryobligatedAmountSpecified = (string)x.Descendants("treasuryobligatedAmountSpecified").FirstOrDefault()
                            ,
                            treasurysubAccountCode = (string)x.Descendants("treasurysubAccountCode").FirstOrDefault()
                            ,
                            treasurysubLevelPrefixCode = (string)x.Descendants("treasurysubLevelPrefixCode").FirstOrDefault()
                            ,
                            typeOfContractPricing = (string)x.Descendants("typeOfContractPricing").FirstOrDefault()
                            ,
                            typeOfContractPricingDesc = (string)x.Descendants("typeOfContractPricing").FirstOrDefault() != null ? (string)x.Descendants("typeOfContractPricing").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            typeOfFeeForUseOfService = (string)x.Descendants("typeOfFeeForUseOfService").FirstOrDefault()
                            ,
                            typeOfFeeForUseOfServiceDesc = (string)x.Descendants("typeOfFeeForUseOfService").FirstOrDefault() != null ? (string)x.Descendants("typeOfFeeForUseOfService").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            typeOfIDC = (string)x.Descendants("typeOfIDC").FirstOrDefault()
                            ,
                            typeOfIDCDesc = (string)x.Descendants("typeOfIDC").FirstOrDefault() != null ? (string)x.Descendants("typeOfIDC").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            typeOfSetAside = (string)x.Descendants("typeOfSetAside").FirstOrDefault()
                            ,
                            typeOfSetAsideDesc = (string)x.Descendants("typeOfSetAside").FirstOrDefault() != null ? (string)x.Descendants("typeOfSetAside").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            ultimateCompletionDate = (string)x.Descendants("ultimateCompletionDate").FirstOrDefault()
                            ,
                            undefinitizedAction = (string)x.Descendants("undefinitizedAction").FirstOrDefault()
                            ,
                            undefinitizedActionDesc = (string)x.Descendants("undefinitizedAction").FirstOrDefault() != null ? (string)x.Descendants("undefinitizedAction").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            useOfEPADesignatedProducts = (string)x.Descendants("useOfEPADesignatedProducts").FirstOrDefault()
                            ,
                            useOfEPADesignatedProductsDesc = (string)x.Descendants("useOfEPADesignatedProducts").FirstOrDefault() != null ? (string)x.Descendants("useOfEPADesignatedProducts").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            vendorAlternateName = (string)x.Descendants("vendorAlternateName").FirstOrDefault()
                            ,
                            vendorAlternateSiteCode = (string)x.Descendants("vendorAlternateSiteCode").FirstOrDefault()
                            ,
                            vendorDoingAsBusinessName = (string)x.Descendants("vendorDoingAsBusinessName").FirstOrDefault() 
                            ,
                            vendorEnabled = (string)x.Descendants("vendorEnabled").FirstOrDefault()
                            ,
                            vendorLegalOrganizationName = (string)x.Descendants("vendorLegalOrganizationName").FirstOrDefault()
                            ,
                            vendorLocationDisabledFlag = (string)x.Descendants("vendorLocationDisabledFlag").FirstOrDefault()
                            ,
                            vendorName = (string)x.Descendants("vendorName").FirstOrDefault() 
                            ,
                            vendorSiteCode = (string)x.Descendants("vendorSiteCode").FirstOrDefault()
                            ,
                            VendorZIPCodeCity = (string)x.Descendants("VendorZIPCodeCity").FirstOrDefault()
                            ,
                            VendorZIPCodeCountry = (string)x.Descendants("VendorZIPCodeCountry").FirstOrDefault()
                            ,
                            WalshHealyAct = (string)x.Descendants("WalshHealyAct").FirstOrDefault()
                            ,
                            WalshHealyActDesc = (string)x.Descendants("WalshHealyAct").FirstOrDefault() != null ? (string)x.Descendants("WalshHealyAct").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            websiteURL = (string)x.Descendants("websiteURL").FirstOrDefault()
                            ,
                            whocanuse = (string)x.Descendants("whocanuse").FirstOrDefault()
                            ,
                            whocanuseDesc = (string)x.Descendants("whocanuse").FirstOrDefault() != null ? (string)x.Descendants("whocanuse").FirstOrDefault().Attribute("description") : (string)null
                            ,
                            ZIPCode = (string)x.Descendants("ZIPCode").FirstOrDefault()

                 };
              #endregion

            foreach (var entry in entries)
            {
                //Console.WriteLine(entry.AgencyID +"\t" + entry.RefAgency);
                using (SqlConnection OpenCon = new SqlConnection("Insert Connection String"))
                {
                    #region TheQuery
                    string qry = @"exec ERA_Staging.[dbo].[usp_InsertUpdateDetailsStaging_ATOM] 
                                     @agencyID
                                    ,@modNumber
                                    ,@PIID
                                    ,@transactionNumber
                                    ,@refIDVIDAgencyID
                                    ,@refIDVIDModNumber
                                    ,@refIDVIDPIID
                                    ,@A76Action
                                    ,@alternateAdvertising
                                    ,@commercialItemAcquisitionProcedures
                                    ,@commercialItemTestProgram
                                    ,@competitveProcedures
                                    ,@evaluatedPreference
                                    ,@extentCompeted
                                    ,@fedBizOpps
                                    ,@localAreaSetAside
                                    ,@numberOfOffersReceived
                                    ,@preAwardSynopsisRequirement
                                    ,@priceEvaluationPercentDifference
                                    ,@reasonNotCompeted
                                    ,@research
                                    ,@smallBusinessCompetitivenessDemonstrationProgram
                                    ,@solicitationProcedures
                                    ,@statutoryExceptionToFairOpportunity
                                    ,@synopsisWaiverException
                                    ,@synopsisWaiverExceptionSpecified
                                    ,@typeOfSetAside
                                    ,@consolidatedContract
                                    ,@contingencyHumanitarianPeacekeepingOperation
                                    ,@contractActionType
                                    ,@contractFinancing
                                    ,@costAccountingStandardsClause
                                    ,@costOrPricingData
                                    ,@descriptionOfContractRequirement
                                    ,@GFEGFP
                                    ,@majorProgramCode
                                    ,@multiYearContract
                                    ,@nationalInterestActionCode
                                    ,@numberOfActions
                                    ,@performanceBasedServiceContract
                                    ,@purchaseCardAsPaymentMethod
                                    ,@reasonForModification
                                    ,@seaTransportation
                                    ,@solicitationID
                                    ,@typeOfContractPricing
                                    ,@undefinitizedAction
                                    ,@feePaidForUseOfService
                                    ,@baseAndAllOptionsValue
                                    ,@baseAndExercisedOptionsValue
                                    ,@obligatedAmount
                                    ,@lastDateToOrder
                                    ,@maximumOrderLimit
                                    ,@typeOfIDC
                                    ,@multipleOrSingleAwardIDC
                                    ,@programAcronym
                                    ,@economyAct
                                    ,@ClingerCohenAct
                                    ,@DavisBaconAct
                                    ,@interagencyContractingAuthority
                                    ,@otherStatutoryAuthority
                                    ,@serviceContractAct
                                    ,@WalshHealyAct
                                    ,@placeOfPerformanceCongressionalDistrict
                                    ,@placeOfPerformanceZIPCode
                                    ,@principalPlaceOfPerformanceCountryCode
                                    ,@principalPlaceOfPerformanceLocationCode
                                    ,@principalPlaceOfPerformanceStateCode
                                    ,@reasonNotAwardedToSmallBusiness
                                    ,@reasonNotAwardedToSmallDisadvantagedBusiness
                                    ,@subcontractPlan
                                    ,@claimantProgramCode
                                    ,@contractBundling
                                    ,@countryOfOrigin
                                    ,@informationTechnologyCommercialItemCategory
                                    ,@manufacturingOrganizationType
                                    ,@placeOfManufacture
                                    ,@principalNAICSCode
                                    ,@productOrServiceCode
                                    ,@recoveredMaterialClauses
                                    ,@systemEquipmentCode
                                    ,@useOfEPADesignatedProducts
                                    ,@contractingOfficeAgencyID
                                    ,@contractingOfficeID
                                    ,@foreignFunding
                                    ,@fundingRequestingAgencyID
                                    ,@fundingRequestingOfficeID
                                    ,@purchaseReason
                                    ,@currentCompletionDate
                                    ,@effectiveDate
                                    ,@signedDate
                                    ,@ultimateCompletionDate
                                    ,@createdBy
                                    ,@createdDate
                                    ,@lastModifiedBy
                                    ,@lastModifiedDate
                                    ,@status
                                    ,@websiteURL
                                    ,@whocanuse
                                    ,@transactionSource
                                    ,@contractingOfficerBusinessSizeDetermination
                                    ,@contractorName
                                    ,@CCRException
                                    ,@vendorAlternateName
                                    ,@vendorDoingAsBusinessName
                                    ,@vendorEnabled
                                    ,@vendorLegalOrganizationName
                                    ,@vendorName
                                    ,@divisionName
                                    ,@divisionNumberOrOfficeCode
                                    ,@vendorAlternateSiteCode
                                    ,@vendorSiteCode
                                    ,@city
                                    ,@congressionalDistrictCode
                                    ,@countryCode
                                    ,@faxNo
                                    ,@phoneNo
                                    ,@province
                                    ,@state
                                    ,@streetAddress
                                    ,@streetAddress2
                                    ,@streetAddress3
                                    ,@vendorLocationDisabledFlag
                                    ,@ZIPCode
                                    ,@annualRevenue
                                    ,@countryOfIncorporation
                                    ,@registrationDate
                                    ,@renewalDate
                                    ,@domesticParentDUNSNumber
                                    ,@DUNSNumber
                                    ,@globalParentDUNSNumber
                                    ,@parentDUNSNumber
                                    ,@numberOfEmployees
                                    ,@organizationalType
                                    ,@stateOfIncorporation
                                    ,@is1862LandGrantCollege
                                    ,@is1890LandGrantCollege
                                    ,@is1994LandGrantCollege
                                    ,@isHistoricallyBlackCollegeOrUniverity
                                    ,@isMinorityInstitution
                                    ,@isPrivateUniversityOrCollege
                                    ,@isSchoolOfForestry
                                    ,@isStateControlledInstituationofHigherLearning
                                    ,@isTribalCollege
                                    ,@isVeterinaryCollege
                                    ,@isAirportAuthority
                                    ,@isCouncilOfGovernments
                                    ,@isHousingAuthoritiesPublicOrTribal
                                    ,@isInterstateEntity
                                    ,@isPlanningCommission
                                    ,@isPortAuthority
                                    ,@isTransitAuthority
                                    ,@isCommunityDevelopedCorporationOwnedFirm
                                    ,@isForeignGovernment
                                    ,@isLaborSurplusAreaFirm
                                    ,@isStateGovernment
                                    ,@isTribalGovernment
                                    ,@isCorporateEntityNotTaxExempt
                                    ,@isCorporateEntityTaxExempt
                                    ,@isInternationalOrganization
                                    ,@isOtherBusinessOrOrganization
                                    ,@isPartnershipOrLimitedLiabilityPartnership
                                    ,@isSmallAgriculturalCooperative
                                    ,@isSoleProprietorship
                                    ,@isFederalGovernment
                                    ,@isFederalGovernmentAgency
                                    ,@isFederallyFundedResearchAndDevelopmentCorp
                                    ,@isCityLocalGovernment
                                    ,@isCountyLocalGovernment
                                    ,@isInterMunicipalLocalGovernment
                                    ,@isLocalGovernment
                                    ,@isLocalGovernmentOwned
                                    ,@isMunicipalityLocalGovernment
                                    ,@isSchoolDistrictLocalGovernment
                                    ,@isTownshipLocalGovernment
                                    ,@isDOTCertifiedDisadvantagedBusinessEnterprise
                                    ,@isSBACertified8AJointVenture
                                    ,@isSBACertified8AProgramParticipant
                                    ,@isSBACertifiedHUBZone
                                    ,@isSBACertifiedSmallDisadvantagedBusiness
                                    ,@isSelfCertifiedSmallDisadvantagedBusiness
                                    ,@isArchitectureAndEngineering
                                    ,@isCommunityDevelopmentCorporation
                                    ,@isConstructionFirm
                                    ,@isDomesticShelter
                                    ,@isEducationalInstitution
                                    ,@isFoundation
                                    ,@isHispanicServicingInstitution
                                    ,@isHospital
                                    ,@isManufacturerOfGoods
                                    ,@isResearchAndDevelopment
                                    ,@isServiceProvider
                                    ,@isVeterinaryHospital
                                    ,@isForeignOwnedAndLocated
                                    ,@isLimitedLiabilityCorporation
                                    ,@isShelteredWorkshop
                                    ,@isSubchapterSCorporation
                                    ,@isForProfitOrganization
                                    ,@isNonprofitOrganization
                                    ,@isOtherNotForProfitOrganization
                                    ,@receivesContracts
                                    ,@receivesContractsAndGrants
                                    ,@receivesGrants
                                    ,@isAlaskanNativeOwnedCorporationOrFirm
                                    ,@isAmericanIndianOwned
                                    ,@isIndianTribe
                                    ,@isNativeHawaiianOwnedOrganizationOrFirm
                                    ,@isServiceRelatedDisabledVeteranOwnedBusiness
                                    ,@isSmallBusiness
                                    ,@isTriballyOwnedFirm
                                    ,@isVerySmallBusiness
                                    ,@isVeteranOwned
                                    ,@isWomenOwned
                                    ,@isAsianPacificAmericanOwnedBusiness
                                    ,@isBlackAmericanOwnedBusiness
                                    ,@isHispanicAmericanOwnedBusiness
                                    ,@isMinorityOwned
                                    ,@isNativeAmericanOwnedBusiness
                                    ,@isOtherMinorityOwned
                                    ,@isSubContinentAsianAmericanOwnedBusiness
                                    ,@extractSource
                                    ,@agencyName
                                    ,@refIDVIDAgencyName
                                    ,@contractingOfficeAgencyName
                                    ,@contractingOfficeName
                                    ,@fundingRequestingAgencyName
                                    ,@fundingRequestingOfficeName
                                    ,@foreignFundingDesc
                                    ,@whocanuseDesc
                                    ,@emailAddress
                                    ,@orderingProcedure
                                    ,@contractActionTypeDesc
                                    ,@typeOfContractPricingDesc
                                    ,@reasonForModificationDesc
                                    ,@nationalInterestActionDesc
                                    ,@costOrPricingDataDesc
                                    ,@costAccountingStandardsClauseDesc
                                    ,@GFEGFPDesc
                                    ,@seaTransportationDesc
                                    ,@undefinitizedActionDesc
                                    ,@consolidatedContractDesc
                                    ,@performanceBasedServiceContractDesc
                                    ,@multiYearContractDesc
                                    ,@typeOfIDCDesc
                                    ,@multipleOrSingleAwardIDCDesc
                                    ,@contingencyHumanitarianPeacekeepingOperationDesc
                                    ,@contractFinancingDesc
                                    ,@purchaseCardAsPaymentMethodDesc
                                    ,@ClingerCohenActDesc
                                    ,@WalshHealyActDesc
                                    ,@serviceContractActDesc
                                    ,@DavisBaconActDesc
                                    ,@interagencyContractingAuthorityDesc
                                    ,@productOrServiceDesc
                                    ,@contractBundlingDesc
                                    ,@claimantProgramDesc
                                    ,@principalNAICSDesc
                                    ,@recoveredMaterialClausesDesc
                                    ,@manufacturingOrganizationTypeDesc
                                    ,@systemEquipmentDesc
                                    ,@informationTechnologyCommercialItemCategoryDesc
                                    ,@useOfEPADesignatedProductsDesc
                                    ,@countryOfOriginName
                                    ,@placeOfManufactureDesc
                                    ,@principalPlaceOfPerformanceStateName
                                    ,@principalPlaceOfPerformanceCountryName
                                    ,@placeOfPerformanceZIPCodeCity
                                    ,@placeOfPerformanceZIPCodeCountry
                                    ,@stateOfIncorporationName
                                    ,@countryOfIncorporationName
                                    ,@countryName
                                    ,@stateName
                                    ,@CCRExceptionDesc
                                    ,@extentCompetedDesc
                                    ,@solicitationProceduresDesc
                                    ,@typeOfSetAsideDesc
                                    ,@evaluatedPreferenceDesc
                                    ,@researchDesc
                                    ,@statutoryExceptionToFairOpportunityDesc
                                    ,@reasonNotCompetedDesc
                                    ,@commercialItemTestProgramDesc
                                    ,@commercialItemAcquisitionProceduresDesc
                                    ,@A76ActionDesc
                                    ,@fedBizOppsDesc
                                    ,@localAreaSetAsideDesc
                                    ,@subcontractPlanDesc
                                    ,@statusDesc
                                    ,@transactionSourceDesc
                                    ,@typeOfFeeForUseOfServiceDesc
                                    ,@VendorZIPCodeCity
                                    ,@VendorZIPCodeCountry
                                    ,@contractingOfficerBusinessSizeDeterminationDesc
                                    ,@typeOfFeeForUseOfService
                                    ,@treasurysubLevelPrefixCode
                                    ,@treasuryallocationTransferAgencyIdentifier
                                    ,@treasuryagencyIdentifier
                                    ,@treasuryagencyIdentifierName
                                    ,@treasurybeginningPeriodOfAvailability
                                    ,@treasuryendingPeriodOfAvailability
                                    ,@treasuryavailabilityTypeCode
                                    ,@treasuryavailabilityTypeDescription
                                    ,@treasurymainAccountCode
                                    ,@treasurysubAccountCode
                                    ,@treasuryinitiative
                                    ,@treasuryinitiativeDescription
                                    ,@treasuryobligatedAmount
                                    ,@treasuryobligatedAmountSpecified
                                    ,@domesticParentDUNSName
                                    ,@globalParentDUNSName
                                    ,@parentDUNSName
                                    ,@recordtype
                                    ,@version
                                    ,@Part8Or13
                    
                    ";

                    #endregion
                    

                    try
                    {
                       

                        using (SqlCommand qryInsert = new SqlCommand(qry))
                        {
                            #region SetParameters

                            qryInsert.Connection = OpenCon;

                            qryInsert.Parameters.Add("@A76Action", SqlDbType.VarChar, 5).Value = (object)entry.A76Action ?? DBNull.Value;
                            qryInsert.Parameters.Add("@A76ActionDesc", SqlDbType.VarChar, 250).Value = (object)entry.A76ActionDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@agencyID", SqlDbType.VarChar, 25).Value = (object)entry.agencyID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@agencyName", SqlDbType.VarChar, 100).Value = (object)entry.agencyName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@alternateAdvertising", SqlDbType.VarChar, 5).Value = (object)entry.alternateAdvertising ?? DBNull.Value;
                            qryInsert.Parameters.Add("@annualRevenue", SqlDbType.Money).Value = (object)entry.annualRevenue ?? DBNull.Value;
                            qryInsert.Parameters.Add("@baseAndAllOptionsValue", SqlDbType.Money).Value = (object)entry.baseAndAllOptionsValue ?? DBNull.Value;
                            qryInsert.Parameters.Add("@baseAndExercisedOptionsValue", SqlDbType.Money).Value = (object)entry.baseAndExercisedOptionsValue ?? DBNull.Value;
                            qryInsert.Parameters.Add("@CCRException", SqlDbType.VarChar, 50).Value = (object)entry.CCRException ?? DBNull.Value;
                            qryInsert.Parameters.Add("@CCRExceptionDesc", SqlDbType.VarChar, 250).Value = (object)entry.CCRExceptionDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@city", SqlDbType.VarChar, 50).Value = (object)entry.city ?? DBNull.Value;
                            qryInsert.Parameters.Add("@claimantProgramCode", SqlDbType.VarChar, 15).Value = (object)entry.claimantProgramCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@claimantProgramDesc", SqlDbType.VarChar, 250).Value = (object)entry.claimantProgramDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@ClingerCohenAct", SqlDbType.VarChar, 5).Value = (object)entry.ClingerCohenAct ?? DBNull.Value;
                            qryInsert.Parameters.Add("@ClingerCohenActDesc", SqlDbType.VarChar, 250).Value = (object)entry.ClingerCohenActDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@commercialItemAcquisitionProcedures", SqlDbType.VarChar, 25).Value = (object)entry.commercialItemAcquisitionProcedures ?? DBNull.Value;
                            qryInsert.Parameters.Add("@commercialItemAcquisitionProceduresDesc", SqlDbType.VarChar, 250).Value = (object)entry.commercialItemAcquisitionProceduresDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@commercialItemTestProgram", SqlDbType.VarChar, 25).Value = (object)entry.commercialItemTestProgram ?? DBNull.Value;
                            qryInsert.Parameters.Add("@commercialItemTestProgramDesc", SqlDbType.VarChar, 250).Value = (object)entry.commercialItemTestProgramDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@competitveProcedures", SqlDbType.VarChar, 25).Value = (object)entry.competitveProcedures ?? DBNull.Value;
                            qryInsert.Parameters.Add("@congressionalDistrictCode", SqlDbType.VarChar, 5).Value = (object)entry.congressionalDistrictCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@consolidatedContract", SqlDbType.VarChar, 5).Value = (object)entry.consolidatedContract ?? DBNull.Value;
                            qryInsert.Parameters.Add("@consolidatedContractDesc", SqlDbType.VarChar, 250).Value = (object)entry.consolidatedContractDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contingencyHumanitarianPeacekeepingOperation", SqlDbType.VarChar, 5).Value = (object)entry.contingencyHumanitarianPeacekeepingOperation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contingencyHumanitarianPeacekeepingOperationDesc", SqlDbType.VarChar, 250).Value = (object)entry.contingencyHumanitarianPeacekeepingOperationDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractActionType", SqlDbType.VarChar, 25).Value = (object)entry.contractActionType ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractActionTypeDesc", SqlDbType.VarChar, 250).Value = (object)entry.contractActionTypeDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractBundling", SqlDbType.VarChar, 5).Value = (object)entry.contractBundling ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractBundlingDesc", SqlDbType.VarChar, 250).Value = (object)entry.contractBundlingDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractFinancing", SqlDbType.VarChar, 50).Value = (object)entry.contractFinancing ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractFinancingDesc", SqlDbType.VarChar, 250).Value = (object)entry.contractFinancingDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficeAgencyID", SqlDbType.VarChar, 25).Value = (object)entry.contractingOfficeAgencyID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficeAgencyName", SqlDbType.VarChar, 100).Value = (object)entry.contractingOfficeAgencyName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficeID", SqlDbType.VarChar, 25).Value = (object)entry.contractingOfficeID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficeName", SqlDbType.VarChar, 100).Value = (object)entry.contractingOfficeName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficerBusinessSizeDetermination", SqlDbType.VarChar, 10).Value = (object)entry.contractingOfficerBusinessSizeDetermination ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractingOfficerBusinessSizeDeterminationDesc", SqlDbType.VarChar, 250).Value = (object)entry.contractingOfficerBusinessSizeDeterminationDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@contractorName", SqlDbType.VarChar, 200).Value = (object)entry.contractorName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@costAccountingStandardsClause", SqlDbType.VarChar, 50).Value = (object)entry.costAccountingStandardsClause ?? DBNull.Value;
                            qryInsert.Parameters.Add("@costAccountingStandardsClauseDesc", SqlDbType.VarChar, 250).Value = (object)entry.costAccountingStandardsClauseDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@costOrPricingData", SqlDbType.VarChar, 50).Value = (object)entry.costOrPricingData ?? DBNull.Value;
                            qryInsert.Parameters.Add("@costOrPricingDataDesc", SqlDbType.VarChar, 250).Value = (object)entry.costOrPricingDataDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryCode", SqlDbType.VarChar, 5).Value = (object)entry.countryCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryName", SqlDbType.VarChar, 100).Value = (object)entry.countryName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryOfIncorporation", SqlDbType.VarChar, 25).Value = (object)entry.countryOfIncorporation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryOfIncorporationName", SqlDbType.VarChar, 100).Value = (object)entry.countryOfIncorporationName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryOfOrigin", SqlDbType.VarChar, 10).Value = (object)entry.countryOfOrigin ?? DBNull.Value;
                            qryInsert.Parameters.Add("@countryOfOriginName", SqlDbType.VarChar, 100).Value = (object)entry.countryOfOriginName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@createdBy", SqlDbType.VarChar, 50).Value = (object)entry.createdBy ?? DBNull.Value;
                            qryInsert.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = (object)entry.createdDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@currentCompletionDate", SqlDbType.DateTime).Value = (object)entry.currentCompletionDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@DavisBaconAct", SqlDbType.VarChar, 5).Value = (object)entry.DavisBaconAct ?? DBNull.Value;
                            qryInsert.Parameters.Add("@DavisBaconActDesc", SqlDbType.VarChar, 250).Value = (object)entry.DavisBaconActDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@descriptionOfContractRequirement", SqlDbType.VarChar, 5000).Value = (object)entry.descriptionOfContractRequirement ?? DBNull.Value;
                            qryInsert.Parameters.Add("@divisionName", SqlDbType.VarChar, 100).Value = (object)entry.divisionName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@divisionNumberOrOfficeCode", SqlDbType.VarChar, 10).Value = (object)entry.divisionNumberOrOfficeCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@domesticParentDUNSNumber", SqlDbType.VarChar, 15).Value = (object)entry.domesticParentDUNSNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@domesticParentDUNSName", SqlDbType.VarChar, 200).Value = (object)entry.domesticParentDUNSName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@DUNSNumber", SqlDbType.VarChar, 15).Value = (object)entry.DUNSNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@economyAct", SqlDbType.VarChar, 5).Value = (object)entry.economyAct ?? DBNull.Value;
                            qryInsert.Parameters.Add("@effectiveDate", SqlDbType.DateTime).Value = (object)entry.effectiveDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@emailAddress", SqlDbType.VarChar, 250).Value = (object)entry.emailAddress ?? DBNull.Value;
                            qryInsert.Parameters.Add("@evaluatedPreference", SqlDbType.VarChar, 25).Value = (object)entry.evaluatedPreference ?? DBNull.Value;
                            qryInsert.Parameters.Add("@evaluatedPreferenceDesc", SqlDbType.VarChar, 250).Value = (object)entry.evaluatedPreferenceDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@extentCompeted", SqlDbType.VarChar, 10).Value = (object)entry.extentCompeted ?? DBNull.Value;
                            qryInsert.Parameters.Add("@extentCompetedDesc", SqlDbType.VarChar, 250).Value = (object)entry.extentCompetedDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@extractSource", SqlDbType.VarChar, 25).Value = "ATOM_FEED" ;
                            qryInsert.Parameters.Add("@faxNo", SqlDbType.VarChar, 15).Value = (object)entry.faxNo ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fedBizOpps", SqlDbType.VarChar, 5).Value = (object)entry.fedBizOpps ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fedBizOppsDesc", SqlDbType.VarChar, 250).Value = (object)entry.fedBizOppsDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@feePaidForUseOfService", SqlDbType.Money).Value = (object)entry.feePaidForUseOfService ?? DBNull.Value;
                            qryInsert.Parameters.Add("@foreignFunding", SqlDbType.VarChar, 5).Value = (object)entry.foreignFunding ?? DBNull.Value;
                            qryInsert.Parameters.Add("@foreignFundingDesc", SqlDbType.VarChar, 250).Value = (object)entry.foreignFundingDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fundingRequestingAgencyID", SqlDbType.VarChar, 25).Value = (object)entry.fundingRequestingAgencyID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fundingRequestingAgencyName", SqlDbType.VarChar, 100).Value = (object)entry.fundingRequestingAgencyName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fundingRequestingOfficeID", SqlDbType.VarChar, 25).Value = (object)entry.fundingRequestingOfficeID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@fundingRequestingOfficeName", SqlDbType.VarChar, 100).Value = (object)entry.fundingRequestingOfficeName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@GFEGFP", SqlDbType.VarChar, 5).Value = (object)entry.GFEGFP ?? DBNull.Value;
                            qryInsert.Parameters.Add("@GFEGFPDesc", SqlDbType.VarChar, 250).Value = (object)entry.GFEGFPDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@globalParentDUNSNumber", SqlDbType.VarChar, 15).Value = (object)entry.globalParentDUNSNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@globalParentDUNSName", SqlDbType.VarChar, 200).Value = (object)entry.globalParentDUNSName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@informationTechnologyCommercialItemCategory", SqlDbType.VarChar, 25).Value = (object)entry.informationTechnologyCommercialItemCategory ?? DBNull.Value;
                            qryInsert.Parameters.Add("@informationTechnologyCommercialItemCategoryDesc", SqlDbType.VarChar, 250).Value = (object)entry.informationTechnologyCommercialItemCategoryDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@interagencyContractingAuthority", SqlDbType.VarChar, 5).Value = (object)entry.interagencyContractingAuthority ?? DBNull.Value;
                            qryInsert.Parameters.Add("@interagencyContractingAuthorityDesc", SqlDbType.VarChar, 250).Value = (object)entry.interagencyContractingAuthorityDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@is1862LandGrantCollege", SqlDbType.Bit).Value = (object)entry.is1862LandGrantCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@is1890LandGrantCollege", SqlDbType.Bit).Value = (object)entry.is1890LandGrantCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@is1994LandGrantCollege", SqlDbType.Bit).Value = (object)entry.is1994LandGrantCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isAirportAuthority", SqlDbType.Bit).Value = (object)entry.isAirportAuthority ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isAlaskanNativeOwnedCorporationOrFirm", SqlDbType.Bit).Value = (object)entry.isAlaskanNativeOwnedCorporationOrFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isAmericanIndianOwned", SqlDbType.Bit).Value = (object)entry.isAmericanIndianOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isArchitectureAndEngineering", SqlDbType.Bit).Value = (object)entry.isArchitectureAndEngineering ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isAsianPacificAmericanOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isAsianPacificAmericanOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isBlackAmericanOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isBlackAmericanOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCityLocalGovernment", SqlDbType.Bit).Value = (object)entry.isCityLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCommunityDevelopedCorporationOwnedFirm", SqlDbType.Bit).Value = (object)entry.isCommunityDevelopedCorporationOwnedFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCommunityDevelopmentCorporation", SqlDbType.Bit).Value = (object)entry.isCommunityDevelopmentCorporation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isConstructionFirm", SqlDbType.Bit).Value = (object)entry.isConstructionFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCorporateEntityNotTaxExempt", SqlDbType.Bit).Value = (object)entry.isCorporateEntityNotTaxExempt ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCorporateEntityTaxExempt", SqlDbType.Bit).Value = (object)entry.isCorporateEntityTaxExempt ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCouncilOfGovernments", SqlDbType.Bit).Value = (object)entry.isCouncilOfGovernments ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isCountyLocalGovernment", SqlDbType.Bit).Value = (object)entry.isCountyLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isDomesticShelter", SqlDbType.Bit).Value = (object)entry.isDomesticShelter ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isDOTCertifiedDisadvantagedBusinessEnterprise", SqlDbType.Bit).Value = (object)entry.isDOTCertifiedDisadvantagedBusinessEnterprise ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isEducationalInstitution", SqlDbType.Bit).Value = (object)entry.isEducationalInstitution ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isFederalGovernment", SqlDbType.Bit).Value = (object)entry.isFederalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isFederalGovernmentAgency", SqlDbType.Bit).Value = (object)entry.isFederalGovernmentAgency ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isFederallyFundedResearchAndDevelopmentCorp", SqlDbType.Bit).Value = (object)entry.isFederallyFundedResearchAndDevelopmentCorp ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isForeignGovernment", SqlDbType.Bit).Value = (object)entry.isForeignGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isForeignOwnedAndLocated", SqlDbType.Bit).Value = (object)entry.isForeignOwnedAndLocated ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isForProfitOrganization", SqlDbType.Bit).Value = (object)entry.isForProfitOrganization ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isFoundation", SqlDbType.Bit).Value = (object)entry.isFoundation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isHispanicAmericanOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isHispanicAmericanOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isHispanicServicingInstitution", SqlDbType.Bit).Value = (object)entry.isHispanicServicingInstitution ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isHistoricallyBlackCollegeOrUniverity", SqlDbType.Bit).Value = (object)entry.isHistoricallyBlackCollegeOrUniverity ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isHospital", SqlDbType.Bit).Value = (object)entry.isHospital ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isHousingAuthoritiesPublicOrTribal", SqlDbType.Bit).Value = (object)entry.isHousingAuthoritiesPublicOrTribal ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isIndianTribe", SqlDbType.Bit).Value = (object)entry.isIndianTribe ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isInterMunicipalLocalGovernment", SqlDbType.Bit).Value = (object)entry.isInterMunicipalLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isInternationalOrganization", SqlDbType.Bit).Value = (object)entry.isInternationalOrganization ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isInterstateEntity", SqlDbType.Bit).Value = (object)entry.isInterstateEntity ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isLaborSurplusAreaFirm", SqlDbType.Bit).Value = (object)entry.isLaborSurplusAreaFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isLimitedLiabilityCorporation", SqlDbType.Bit).Value = (object)entry.isLimitedLiabilityCorporation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isLocalGovernment", SqlDbType.Bit).Value = (object)entry.isLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isLocalGovernmentOwned", SqlDbType.Bit).Value = (object)entry.isLocalGovernmentOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isManufacturerOfGoods", SqlDbType.Bit).Value = (object)entry.isManufacturerOfGoods ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isMinorityInstitution", SqlDbType.Bit).Value = (object)entry.isMinorityInstitution ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isMinorityOwned", SqlDbType.Bit).Value = (object)entry.isMinorityOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isMunicipalityLocalGovernment", SqlDbType.Bit).Value = (object)entry.isMunicipalityLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isNativeAmericanOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isNativeAmericanOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isNativeHawaiianOwnedOrganizationOrFirm", SqlDbType.Bit).Value = (object)entry.isNativeHawaiianOwnedOrganizationOrFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isNonprofitOrganization", SqlDbType.Bit).Value = (object)entry.isNonprofitOrganization ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isOtherBusinessOrOrganization", SqlDbType.Bit).Value = (object)entry.isOtherBusinessOrOrganization ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isOtherMinorityOwned", SqlDbType.Bit).Value = (object)entry.isOtherMinorityOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isOtherNotForProfitOrganization", SqlDbType.Bit).Value = (object)entry.isOtherNotForProfitOrganization ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isPartnershipOrLimitedLiabilityPartnership", SqlDbType.Bit).Value = (object)entry.isPartnershipOrLimitedLiabilityPartnership ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isPlanningCommission", SqlDbType.Bit).Value = (object)entry.isPlanningCommission ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isPortAuthority", SqlDbType.Bit).Value = (object)entry.isPortAuthority ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isPrivateUniversityOrCollege", SqlDbType.Bit).Value = (object)entry.isPrivateUniversityOrCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isResearchAndDevelopment", SqlDbType.Bit).Value = (object)entry.isResearchAndDevelopment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSBACertified8AJointVenture", SqlDbType.Bit).Value = (object)entry.isSBACertified8AJointVenture ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSBACertified8AProgramParticipant", SqlDbType.Bit).Value = (object)entry.isSBACertified8AProgramParticipant ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSBACertifiedHUBZone", SqlDbType.Bit).Value = (object)entry.isSBACertifiedHUBZone ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSBACertifiedSmallDisadvantagedBusiness", SqlDbType.Bit).Value = (object)entry.isSBACertifiedSmallDisadvantagedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSchoolDistrictLocalGovernment", SqlDbType.Bit).Value = (object)entry.isSchoolDistrictLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSchoolOfForestry", SqlDbType.Bit).Value = (object)entry.isSchoolOfForestry ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSelfCertifiedSmallDisadvantagedBusiness", SqlDbType.Bit).Value = (object)entry.isSelfCertifiedSmallDisadvantagedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isServiceProvider", SqlDbType.Bit).Value = (object)entry.isServiceProvider ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isServiceRelatedDisabledVeteranOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isServiceRelatedDisabledVeteranOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isShelteredWorkshop", SqlDbType.Bit).Value = (object)entry.isShelteredWorkshop ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSmallAgriculturalCooperative", SqlDbType.Bit).Value = (object)entry.isSmallAgriculturalCooperative ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSmallBusiness", SqlDbType.Bit).Value = (object)entry.isSmallBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSoleProprietorship", SqlDbType.Bit).Value = (object)entry.isSoleProprietorship ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isStateControlledInstituationofHigherLearning", SqlDbType.Bit).Value = (object)entry.isStateControlledInstituationofHigherLearning ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isStateGovernment", SqlDbType.Bit).Value = (object)entry.isStateGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSubchapterSCorporation", SqlDbType.Bit).Value = (object)entry.isSubchapterSCorporation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isSubContinentAsianAmericanOwnedBusiness", SqlDbType.Bit).Value = (object)entry.isSubContinentAsianAmericanOwnedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isTownshipLocalGovernment", SqlDbType.Bit).Value = (object)entry.isTownshipLocalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isTransitAuthority", SqlDbType.Bit).Value = (object)entry.isTransitAuthority ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isTribalCollege", SqlDbType.Bit).Value = (object)entry.isTribalCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isTribalGovernment", SqlDbType.Bit).Value = (object)entry.isTribalGovernment ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isTriballyOwnedFirm", SqlDbType.Bit).Value = (object)entry.isTriballyOwnedFirm ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isVerySmallBusiness", SqlDbType.Bit).Value = (object)entry.isVerySmallBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isVeteranOwned", SqlDbType.Bit).Value = (object)entry.isVeteranOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isVeterinaryCollege", SqlDbType.Bit).Value = (object)entry.isVeterinaryCollege ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isVeterinaryHospital", SqlDbType.Bit).Value = (object)entry.isVeterinaryHospital ?? DBNull.Value;
                            qryInsert.Parameters.Add("@isWomenOwned", SqlDbType.Bit).Value = (object)entry.isWomenOwned ?? DBNull.Value;
                            qryInsert.Parameters.Add("@lastDateToOrder", SqlDbType.DateTime).Value = (object)entry.lastDateToOrder ?? DBNull.Value;
                            qryInsert.Parameters.Add("@lastModifiedBy", SqlDbType.VarChar, 50).Value = (object)entry.lastModifiedBy ?? DBNull.Value;
                            qryInsert.Parameters.Add("@lastModifiedDate", SqlDbType.DateTime).Value = (object)entry.lastModifiedDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@localAreaSetAside", SqlDbType.VarChar, 5).Value = (object)entry.localAreaSetAside ?? DBNull.Value;
                            qryInsert.Parameters.Add("@localAreaSetAsideDesc", SqlDbType.VarChar, 250).Value = (object)entry.localAreaSetAsideDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@majorProgramCode", SqlDbType.VarChar, 100).Value = (object)entry.majorProgramCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@manufacturingOrganizationType", SqlDbType.VarChar, 15).Value = (object)entry.manufacturingOrganizationType ?? DBNull.Value;
                            qryInsert.Parameters.Add("@manufacturingOrganizationTypeDesc", SqlDbType.VarChar, 250).Value = (object)entry.manufacturingOrganizationTypeDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@maximumOrderLimit", SqlDbType.Money).Value = (object)entry.maximumOrderLimit ?? DBNull.Value;
                            qryInsert.Parameters.Add("@modNumber", SqlDbType.VarChar, 25).Value = (object)entry.modNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@multipleOrSingleAwardIDC", SqlDbType.VarChar, 5).Value = (object)entry.multipleOrSingleAwardIDC ?? DBNull.Value;
                            qryInsert.Parameters.Add("@multipleOrSingleAwardIDCDesc", SqlDbType.VarChar, 250).Value = (object)entry.multipleOrSingleAwardIDCDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@multiYearContract", SqlDbType.VarChar, 5).Value = (object)entry.multiYearContract ?? DBNull.Value;
                            qryInsert.Parameters.Add("@multiYearContractDesc", SqlDbType.VarChar, 250).Value = (object)entry.multiYearContractDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@nationalInterestActionCode", SqlDbType.VarChar, 25).Value = (object)entry.nationalInterestActionCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@nationalInterestActionDesc", SqlDbType.VarChar, 250).Value = (object)entry.nationalInterestActionDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@numberOfActions", SqlDbType.Int).Value = (object)entry.numberOfActions ?? DBNull.Value;
                            qryInsert.Parameters.Add("@numberOfEmployees", SqlDbType.Int).Value = (object)entry.numberOfEmployees ?? DBNull.Value;
                            qryInsert.Parameters.Add("@numberOfOffersReceived", SqlDbType.Int).Value = (object)entry.numberOfOffersReceived ?? DBNull.Value;
                            qryInsert.Parameters.Add("@obligatedAmount", SqlDbType.Money).Value = (object)entry.obligatedAmount ?? DBNull.Value;
                            qryInsert.Parameters.Add("@orderingProcedure", SqlDbType.VarChar, 250).Value = (object)entry.orderingProcedure ?? DBNull.Value;
                            qryInsert.Parameters.Add("@organizationalType", SqlDbType.VarChar, 50).Value = (object)entry.organizationalType ?? DBNull.Value;
                            qryInsert.Parameters.Add("@otherStatutoryAuthority", SqlDbType.VarChar, 5).Value = (object)entry.otherStatutoryAuthority ?? DBNull.Value;
                            qryInsert.Parameters.Add("@parentDUNSNumber", SqlDbType.VarChar, 15).Value = (object)entry.parentDUNSNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@parentDUNSName", SqlDbType.VarChar, 200).Value = (object)entry.parentDUNSName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@performanceBasedServiceContract", SqlDbType.VarChar, 5).Value = (object)entry.performanceBasedServiceContract ?? DBNull.Value;
                            qryInsert.Parameters.Add("@performanceBasedServiceContractDesc", SqlDbType.VarChar, 250).Value = (object)entry.performanceBasedServiceContractDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@phoneNo", SqlDbType.VarChar, 15).Value = (object)entry.phoneNo ?? DBNull.Value;
                            qryInsert.Parameters.Add("@PIID", SqlDbType.VarChar, 50).Value = (object)entry.PIID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfManufacture", SqlDbType.VarChar, 50).Value = (object)entry.placeOfManufacture ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfManufactureDesc", SqlDbType.VarChar, 250).Value = (object)entry.placeOfManufactureDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfPerformanceCongressionalDistrict", SqlDbType.VarChar, 5).Value = (object)entry.placeOfPerformanceCongressionalDistrict ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfPerformanceZIPCode", SqlDbType.VarChar, 12).Value = (object)entry.placeOfPerformanceZIPCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfPerformanceZIPCodeCity", SqlDbType.VarChar, 100).Value = (object)entry.placeOfPerformanceZIPCodeCity ?? DBNull.Value;
                            qryInsert.Parameters.Add("@placeOfPerformanceZIPCodeCountry", SqlDbType.VarChar, 100).Value = (object)entry.placeOfPerformanceZIPCodeCountry ?? DBNull.Value;
                            qryInsert.Parameters.Add("@preAwardSynopsisRequirement", SqlDbType.VarChar, 25).Value = (object)entry.preAwardSynopsisRequirement ?? DBNull.Value;
                            qryInsert.Parameters.Add("@priceEvaluationPercentDifference", SqlDbType.Decimal, 10).Value = (object)entry.priceEvaluationPercentDifference ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalNAICSCode", SqlDbType.VarChar, 15).Value = (object)entry.principalNAICSCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalNAICSDesc", SqlDbType.VarChar, 250).Value = (object)entry.principalNAICSDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalPlaceOfPerformanceCountryCode", SqlDbType.VarChar, 5).Value = (object)entry.principalPlaceOfPerformanceCountryCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalPlaceOfPerformanceCountryName", SqlDbType.VarChar, 100).Value = (object)entry.principalPlaceOfPerformanceCountryName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalPlaceOfPerformanceLocationCode", SqlDbType.VarChar, 10).Value = (object)entry.principalPlaceOfPerformanceLocationCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalPlaceOfPerformanceStateCode", SqlDbType.VarChar, 2).Value = (object)entry.principalPlaceOfPerformanceStateCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@principalPlaceOfPerformanceStateName", SqlDbType.VarChar, 100).Value = (object)entry.principalPlaceOfPerformanceStateName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@productOrServiceCode", SqlDbType.VarChar, 10).Value = (object)entry.productOrServiceCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@productOrServiceDesc", SqlDbType.VarChar, 250).Value = (object)entry.productOrServiceDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@programAcronym", SqlDbType.VarChar, 50).Value = (object)entry.programAcronym ?? DBNull.Value;
                            qryInsert.Parameters.Add("@province", SqlDbType.VarChar, 50).Value = (object)entry.province ?? DBNull.Value;
                            qryInsert.Parameters.Add("@purchaseCardAsPaymentMethod", SqlDbType.VarChar, 5).Value = (object)entry.purchaseCardAsPaymentMethod ?? DBNull.Value;
                            qryInsert.Parameters.Add("@purchaseCardAsPaymentMethodDesc", SqlDbType.VarChar, 250).Value = (object)entry.purchaseCardAsPaymentMethodDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@purchaseReason", SqlDbType.VarChar, 100).Value = (object)entry.purchaseReason ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonForModification", SqlDbType.VarChar, 200).Value = (object)entry.reasonForModification ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonForModificationDesc", SqlDbType.VarChar, 250).Value = (object)entry.reasonForModificationDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonNotAwardedToSmallBusiness", SqlDbType.VarChar, 200).Value = (object)entry.reasonNotAwardedToSmallBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonNotAwardedToSmallDisadvantagedBusiness", SqlDbType.VarChar, 200).Value = (object)entry.reasonNotAwardedToSmallDisadvantagedBusiness ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonNotCompeted", SqlDbType.VarChar, 200).Value = (object)entry.reasonNotCompeted ?? DBNull.Value;
                            qryInsert.Parameters.Add("@reasonNotCompetedDesc", SqlDbType.VarChar, 250).Value = (object)entry.reasonNotCompetedDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@receivesContracts", SqlDbType.Bit).Value = (object)entry.receivesContracts ?? DBNull.Value;
                            qryInsert.Parameters.Add("@receivesContractsAndGrants", SqlDbType.Bit).Value = (object)entry.receivesContractsAndGrants ?? DBNull.Value;
                            qryInsert.Parameters.Add("@receivesGrants", SqlDbType.Bit).Value = (object)entry.receivesGrants ?? DBNull.Value;
                            qryInsert.Parameters.Add("@recoveredMaterialClauses", SqlDbType.VarChar, 5).Value = (object)entry.recoveredMaterialClauses ?? DBNull.Value;
                            qryInsert.Parameters.Add("@recoveredMaterialClausesDesc", SqlDbType.VarChar, 250).Value = (object)entry.recoveredMaterialClausesDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@refIDVIDAgencyID", SqlDbType.VarChar, 25).Value = (object)entry.refIDVIDAgencyID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@refIDVIDAgencyName", SqlDbType.VarChar, 100).Value = (object)entry.refIDVIDAgencyName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@refIDVIDModNumber", SqlDbType.VarChar, 25).Value = (object)entry.refIDVIDModNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@refIDVIDPIID", SqlDbType.VarChar, 50).Value = (object)entry.refIDVIDPIID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@registrationDate", SqlDbType.DateTime).Value = (object)entry.registrationDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@renewalDate", SqlDbType.DateTime).Value = (object)entry.renewalDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@research", SqlDbType.VarChar, 25).Value = (object)entry.research ?? DBNull.Value;
                            qryInsert.Parameters.Add("@researchDesc", SqlDbType.VarChar, 250).Value = (object)entry.researchDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@seaTransportation", SqlDbType.VarChar, 5).Value = (object)entry.seaTransportation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@seaTransportationDesc", SqlDbType.VarChar, 250).Value = (object)entry.seaTransportationDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@serviceContractAct", SqlDbType.VarChar, 5).Value = (object)entry.serviceContractAct ?? DBNull.Value;
                            qryInsert.Parameters.Add("@serviceContractActDesc", SqlDbType.VarChar, 250).Value = (object)entry.serviceContractActDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@signedDate", SqlDbType.DateTime).Value = (object)entry.signedDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@smallBusinessCompetitivenessDemonstrationProgram", SqlDbType.VarChar, 10).Value = (object)(entry.smallBusinessCompetitivenessDemonstrationProgram == "TRUE" ? "1" : "0") ?? DBNull.Value;
                            qryInsert.Parameters.Add("@solicitationID", SqlDbType.VarChar, 25).Value = (object)entry.solicitationID ?? DBNull.Value;
                            qryInsert.Parameters.Add("@solicitationProcedures", SqlDbType.VarChar, 10).Value = (object)entry.solicitationProcedures ?? DBNull.Value;
                            qryInsert.Parameters.Add("@solicitationProceduresDesc", SqlDbType.VarChar, 250).Value = (object)entry.solicitationProceduresDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@state", SqlDbType.VarChar, 2).Value = (object)entry.state ?? DBNull.Value;
                            qryInsert.Parameters.Add("@stateName", SqlDbType.VarChar, 100).Value = (object)entry.stateName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@stateOfIncorporation", SqlDbType.VarChar, 2).Value = (object)entry.stateOfIncorporation ?? DBNull.Value;
                            qryInsert.Parameters.Add("@stateOfIncorporationName", SqlDbType.VarChar, 100).Value = (object)entry.stateOfIncorporationName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@status", SqlDbType.VarChar, 2).Value = (object)entry.status ?? DBNull.Value;
                            qryInsert.Parameters.Add("@statusDesc", SqlDbType.VarChar, 250).Value = (object)entry.statusDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@statutoryExceptionToFairOpportunity", SqlDbType.VarChar, 25).Value = (object)entry.statutoryExceptionToFairOpportunity ?? DBNull.Value;
                            qryInsert.Parameters.Add("@statutoryExceptionToFairOpportunityDesc", SqlDbType.VarChar, 250).Value = (object)entry.statutoryExceptionToFairOpportunityDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@streetAddress", SqlDbType.VarChar, 50).Value = (object)entry.streetAddress ?? DBNull.Value;
                            qryInsert.Parameters.Add("@streetAddress2", SqlDbType.VarChar, 50).Value = (object)entry.streetAddress2 ?? DBNull.Value;
                            qryInsert.Parameters.Add("@streetAddress3", SqlDbType.VarChar, 50).Value = (object)entry.streetAddress3 ?? DBNull.Value;
                            qryInsert.Parameters.Add("@subcontractPlan", SqlDbType.VarChar, 15).Value = (object)entry.subcontractPlan ?? DBNull.Value;
                            qryInsert.Parameters.Add("@subcontractPlanDesc", SqlDbType.VarChar, 250).Value = (object)entry.subcontractPlanDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@synopsisWaiverException", SqlDbType.VarChar, 25).Value = (object)entry.synopsisWaiverException ?? DBNull.Value;
                            qryInsert.Parameters.Add("@synopsisWaiverExceptionSpecified", SqlDbType.Bit).Value = (object)entry.synopsisWaiverExceptionSpecified ?? DBNull.Value;
                            qryInsert.Parameters.Add("@systemEquipmentCode", SqlDbType.VarChar, 5).Value = (object)entry.systemEquipmentCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@systemEquipmentDesc", SqlDbType.VarChar, 250).Value = (object)entry.systemEquipmentDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@transactionNumber", SqlDbType.Int).Value = (object)entry.transactionNumber ?? DBNull.Value;
                            qryInsert.Parameters.Add("@transactionSource", SqlDbType.VarChar, 255).Value = (object)entry.transactionSource ?? DBNull.Value;
                            qryInsert.Parameters.Add("@transactionSourceDesc", SqlDbType.VarChar, 250).Value = (object)entry.transactionSourceDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryagencyIdentifier", SqlDbType.VarChar, 25).Value = (object)entry.treasuryagencyIdentifier ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryagencyIdentifierName", SqlDbType.VarChar, 100).Value = (object)entry.treasuryagencyIdentifierName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryallocationTransferAgencyIdentifier", SqlDbType.VarChar, 25).Value = (object)entry.treasuryallocationTransferAgencyIdentifier ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryavailabilityTypeCode", SqlDbType.VarChar, 100).Value = (object)entry.treasuryavailabilityTypeCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryavailabilityTypeDescription", SqlDbType.VarChar, 200).Value = (object)entry.treasuryavailabilityTypeDescription ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasurybeginningPeriodOfAvailability", SqlDbType.DateTime).Value = (object)entry.treasurybeginningPeriodOfAvailability ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryendingPeriodOfAvailability", SqlDbType.DateTime).Value = (object)entry.treasuryendingPeriodOfAvailability ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryinitiative", SqlDbType.VarChar, 100).Value = (object)entry.treasuryinitiative ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryinitiativeDescription", SqlDbType.VarChar, 200).Value = (object)entry.treasuryinitiativeDescription ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasurymainAccountCode", SqlDbType.VarChar, 25).Value = (object)entry.treasurymainAccountCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryobligatedAmount", SqlDbType.Money).Value = (object)entry.treasuryobligatedAmount ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasuryobligatedAmountSpecified", SqlDbType.Money).Value = (object)entry.treasuryobligatedAmountSpecified ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasurysubAccountCode", SqlDbType.VarChar, 25).Value = (object)entry.treasurysubAccountCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@treasurysubLevelPrefixCode", SqlDbType.VarChar, 25).Value = (object)entry.treasurysubLevelPrefixCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfContractPricing", SqlDbType.VarChar, 25).Value = (object)entry.typeOfContractPricing ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfContractPricingDesc", SqlDbType.VarChar, 250).Value = (object)entry.typeOfContractPricingDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfFeeForUseOfService", SqlDbType.VarChar, 100).Value = (object)entry.typeOfFeeForUseOfService ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfFeeForUseOfServiceDesc", SqlDbType.VarChar, 250).Value = (object)entry.typeOfFeeForUseOfServiceDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfIDC", SqlDbType.VarChar, 25).Value = (object)entry.typeOfIDC ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfIDCDesc", SqlDbType.VarChar, 250).Value = (object)entry.typeOfIDCDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfSetAside", SqlDbType.VarChar, 25).Value = (object)entry.typeOfSetAside ?? DBNull.Value;
                            qryInsert.Parameters.Add("@typeOfSetAsideDesc", SqlDbType.VarChar, 250).Value = (object)entry.typeOfSetAsideDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@ultimateCompletionDate", SqlDbType.DateTime).Value = (object)entry.ultimateCompletionDate ?? DBNull.Value;
                            qryInsert.Parameters.Add("@undefinitizedAction", SqlDbType.VarChar, 5).Value = (object)entry.undefinitizedAction ?? DBNull.Value;
                            qryInsert.Parameters.Add("@undefinitizedActionDesc", SqlDbType.VarChar, 250).Value = (object)entry.undefinitizedActionDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@useOfEPADesignatedProducts", SqlDbType.VarChar, 5).Value = (object)entry.useOfEPADesignatedProducts ?? DBNull.Value;
                            qryInsert.Parameters.Add("@useOfEPADesignatedProductsDesc", SqlDbType.VarChar, 250).Value = (object)entry.useOfEPADesignatedProductsDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorAlternateName", SqlDbType.VarChar, 200).Value = (object)entry.vendorAlternateName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorAlternateSiteCode", SqlDbType.VarChar, 25).Value = (object)entry.vendorAlternateSiteCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorDoingAsBusinessName", SqlDbType.VarChar, 200).Value = (object)entry.vendorDoingAsBusinessName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorEnabled", SqlDbType.VarChar, 5).Value = (object)entry.vendorEnabled ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorLegalOrganizationName", SqlDbType.VarChar, 200).Value = (object)entry.vendorLegalOrganizationName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorLocationDisabledFlag", SqlDbType.VarChar, 5).Value = (object)entry.vendorLocationDisabledFlag ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorName", SqlDbType.VarChar, 200).Value = (object)entry.vendorName ?? DBNull.Value;
                            qryInsert.Parameters.Add("@vendorSiteCode", SqlDbType.VarChar, 25).Value = (object)entry.vendorSiteCode ?? DBNull.Value;
                            qryInsert.Parameters.Add("@VendorZIPCodeCity", SqlDbType.VarChar, 100).Value = (object)entry.VendorZIPCodeCity ?? DBNull.Value;
                            qryInsert.Parameters.Add("@VendorZIPCodeCountry", SqlDbType.VarChar, 100).Value = (object)entry.VendorZIPCodeCountry ?? DBNull.Value;
                            qryInsert.Parameters.Add("@WalshHealyAct", SqlDbType.VarChar, 5).Value = (object)entry.WalshHealyAct ?? DBNull.Value;
                            qryInsert.Parameters.Add("@WalshHealyActDesc", SqlDbType.VarChar, 250).Value = (object)entry.WalshHealyActDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@websiteURL", SqlDbType.VarChar, 300).Value = (object)entry.websiteURL ?? DBNull.Value;
                            qryInsert.Parameters.Add("@whocanuse", SqlDbType.VarChar, 200).Value = (object)entry.whocanuse ?? DBNull.Value;
                            qryInsert.Parameters.Add("@whocanuseDesc", SqlDbType.VarChar, 250).Value = (object)entry.whocanuseDesc ?? DBNull.Value;
                            qryInsert.Parameters.Add("@ZIPCode", SqlDbType.VarChar, 50).Value = (object)entry.ZIPCode ?? DBNull.Value;
                            qryInsert.Parameters.AddWithValue("@recordtype", AwardOrIDV);
                            qryInsert.Parameters.Add("@version", SqlDbType.VarChar, 25).Value = (object)entry.version ?? DBNull.Value;
                            qryInsert.Parameters.Add("@Part8Or13", SqlDbType.VarChar, 25).Value = (object)entry.contractActionTypePart8Or13 ?? DBNull.Value;





                            //Build BusKey
                            string leftPadSmallMod = "";
                            switch (entry.modNumber.Length)
                            {
                                case 0:
                                    leftPadSmallMod = "0000";
                                    break;
                                case 1:
                                    leftPadSmallMod = "000" + entry.modNumber;
                                    break;
                                case 2:
                                    leftPadSmallMod = "00" + entry.modNumber;
                                    break;
                                case 3:
                                    leftPadSmallMod = "0" + entry.modNumber;
                                    break;
                                default:
                                    leftPadSmallMod = entry.modNumber;
                                    break;
                            }

                            string BusinessUniqueKey = entry.agencyID + entry.PIID + leftPadSmallMod + entry.refIDVIDPIID;

                            qryInsert.Parameters.Add("@BusinessUniqueKey", SqlDbType.VarChar, 150).Value = BusinessUniqueKey;

                            #endregion

                            OpenCon.Open();
                            qryInsert.ExecuteNonQuery();

                            OpenCon.Close();

                            sb.AppendLine("Successfully processed PIID: " + entry.PIID.ToString() + "\t" + entry.modNumber +"\t" + "Agency: " + entry.agencyID.ToString() + "\t" + AwardOrIDV);

                            

                            //Console.WriteLine(entry.agencyIDdesc);
                        }
                    }
                    catch (Exception e)
                    {
                        sb.AppendLine(entry.PIID.ToString() + " failed to enter into database");
                        sb.AppendLine(e.Message);
                        
                    }

                    ActionCounter++;
                           //return recordsAffected;
                }




            } return ActionCounter;
            //Console.WriteLine("You are done");
            
        }
    }
 }