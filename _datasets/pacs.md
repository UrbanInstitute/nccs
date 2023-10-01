---
title: 527 Political Action Committees
date: 2023-05-30 12:00:00
description: Electronic filings made by 527 organizations. 
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/README.md"
  - text: "Data Dictionary"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/data-dictionary.md"
  - text: "Data Dictionary CSV"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/tidy-data-dictionary.csv"
  - text: "R Program"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/parse-pol-org-disclosures.R"
categories:
  - elections
  - campaign finance
  - 501c4
featured: true
featuredOrder: 4
---

## Political Nonprofits

Nonprofits with 527 status are organized primarily to "influence the selection, nomination, election, appointment or defeat of candidates to federal, state or local public office".

## Usage

```r
# 2023-05-POL-ORGS-FM-8871.csv  >>  Organization Information including Officers/Directors and Related Entities
# 2023-05-POL-ORGS-FM-8872.csv  >>  Political donations data 
# 2023-05-POL-ORGS-SCHED-A.csv
# 2023-05-POL-ORGS-SCHED-B.csv
# 2023-05-POL-ORGS-SCHED-D.csv
# 2023-05-POL-ORGS-SCHED-E.csv
# 2023-05-POL-ORGS-SCHED-R.csv 

# DATA PREVIEW

library( dplyr )
library( pander )

URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/"
FILENAME <- "2023-05-POL-ORGS-FM-8871.csv"
d <- read.csv( paste0( URL, FILENAME ) )
head(d) %>% pander()
```



--------------------------------------------------------------------------
      ORGANIZATION_NAME           EIN                 PURPOSE             
----------------------------- ----------- --------------------------------
   Dan Swecker for Senate      912121950        Tax exempt political      
          Campaign                            organization - Political    
                                                      campaign            

   FRIENDS OF TOM CALDERON     954857244   RAISE FUNDS TO ELECT CANDIDATE 

          ASGM PAC             61596525    POLITICAL ACTION COMMITTEE TO  
                                           PROMOTE LEGISLATION FAVORABLE  
                                           TO WORKERS COMPENSATION SAFETY 
                                             GROUPS IN NEW YORK STATE.    

 Comm to Elect Judge Robert    113601603   Committe to Elect Judge Robert 
    Ross to Supreme Court                   Ross to the Supreme Court of  
                                               the State of New York      

 CAMPAIGN TO RE ELECT BOB MC   912082049       SENATORIAL RE ELECTION     
           CASLIN                                     CAMPAIGN            

  Rosanne Bader for Mt. SAC    3.31e+08    Promoting and fundraising for  
        School Board                         candidate for election to    
                                                       office             
--------------------------------------------------------------------------

Table: Table continues below

 
---------------------------------------------------------------------
 RECORD_TYPE   FORM_TYPE   FORM_ID_NUMBER   INITIAL_REPORT_INDICATOR 
------------- ----------- ---------------- --------------------------
      1          8871            8                     0             

      1          8871            9                     0             

      1          8871            10                    0             

      1          8871            11                    0             

      1          8871            12                    0             

      1          8871            13                    0             
---------------------------------------------------------------------

Table: Table continues below

 
------------------------------------------------------------------------------
 AMENDED_REPORT_INDICATOR   FINAL_REPORT_INDICATOR      MAILING_ADDRESS_1     
-------------------------- ------------------------ --------------------------
            0                         0                10420 - 173rd Ave SW   

            0                         0                 728 W. EDNA PLACE     

            0                         0               WILLIAM S WEBB CO INC   

            0                         0              105-15 Metropolitan Ave. 

            0                         0                  10424 E. CENTRAL     

            0                         0                 5041 La Mart Drive    
------------------------------------------------------------------------------

Table: Table continues below

 
-------------------------------------------------------------------
 MAILING_ADDRESS_2    MAILING_ADDRESS_CITY   MAILING_ADDRESS_STATE 
-------------------- ---------------------- -----------------------
                           Rochester                  WA           

                             COVINA                   CA           

 377 OAK ST - CS601       GARDEN CITY                 NY           

                          Forest Hills                NY           

                            SPOKANE                   WA           

     Suite 110             Riverside                  CA           
-------------------------------------------------------------------

Table: Table continues below

 
-----------------------------------------------------------------------
 MAILING_ADDRESS_ZIP_CODE   MAILING_ADDRESS_ZIP_EXT   ESTABLISHED_DATE 
-------------------------- ------------------------- ------------------
          98579                       NA                     NA        

          91722                       NA                     NA        

          11530                       601                    NA        

          11375                       NA                     NA        

          99217                       NA                     NA        

          92507                       NA                     NA        
-----------------------------------------------------------------------

Table: Table continues below

 
--------------------------------------------------------------------------
    CUSTODIAN_NAME       CUSTODIAN_ADDRESS_CITY   CUSTODIAN_ADDRESS_STATE 
----------------------- ------------------------ -------------------------
      Dan Swecker              Rochester                    WA            

    YOLANDA MIRANDA              COVINA                     CA            

   RICHARD C BLIVEN           GARDEN CITY                   NY            

    John A. Gemelli           Forest Hills                  NY            

     HERB MCINTOSH              SPOKANE                     WA            

 Trimble Morin and Co.         Riverside                    CA            
--------------------------------------------------------------------------

Table: Table continues below

 
------------------------------------------------------------------------------
 CUSTODIAN_ADDRESS_ZIP_CODE   CUSTODIAN_ADDRESS_ZIP_EXT   CONTACT_PERSON_NAME 
---------------------------- --------------------------- ---------------------
           98579                         NA                   Dan Swecker     

           91722                         NA                 YOLANDA MIRANDA   

           11530                         601               RICHARD C BLIVEN   

           11375                         NA                 John A. Gemelli   

           99217                         NA                      SAME         

           92507                         NA               Dana Oldenburg, CPA 
------------------------------------------------------------------------------

Table: Table continues below

 
-------------------------------------------------------------------------
 CONTACT_ADDRESS_CITY   CONTACT_ADDRESS_STATE   CONTACT_ADDRESS_ZIP_CODE 
---------------------- ----------------------- --------------------------
      Rochester                  WA                      98579           

        COVINA                   CA                      91722           

     GARDEN CITY                 NY                      11530           

     Forest Hills                NY                      11375           

       SPOKANE                   WA                      99217           

      Riverside                  CA                      92507           
-------------------------------------------------------------------------

Table: Table continues below

 
-------------------------------------------------------------------------
 CONTACT_ADDRESS_ZIP_EXT      BUSINESS_ADDRESS_1      BUSINESS_ADDRESS_2 
------------------------- -------------------------- --------------------
           NA                        same                                

           NA                 728 W. EDNA PLACE                          

           601              WILLIAM S WEBB CO INC     377 OAK ST - CS601 

           NA              105-15 Metropolitan Ave.                      

           NA                  10424 E. CENTRAL                          

           NA                 5041 La Mart Drive          Suite 110      
-------------------------------------------------------------------------

Table: Table continues below

 
-------------------------------------------------------------
 EXEMPT_8872_INDICATOR   EXEMPT_STATE   EXEMPT_990_INDICATOR 
----------------------- -------------- ----------------------
          NA                                     NA          

          NA                                     NA          

          NA                                     NA          

          NA                                     NA          

          NA                                     NA          

          NA                                     NA          
-------------------------------------------------------------

Table: Table continues below

 
----------------------------------------------------------------------------------
 MATERIAL_CHANGE_DATE     INSERT_DATETIME     RELATED_ENTITY_BYPASS   EAIN_BYPASS 
---------------------- --------------------- ----------------------- -------------
          NA            2001-05-13 21:20:54             0                  1      

          NA            2001-05-14 15:05:31             1                  1      

          NA            2001-05-14 17:24:52             1                  1      

          NA            2001-05-15 10:12:56             1                  1      

          NA            2001-05-15 15:25:27             1                  1      

          NA            2001-05-15 16:20:48             1                  1      
----------------------------------------------------------------------------------


