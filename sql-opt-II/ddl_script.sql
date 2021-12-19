CREATE TABLE CANDYHIST_1(RESPONDENT_ID NUMBER,
                         RESPONDENT_NAME VARCHAR2(100),
                         RESPONDENT_ADDR VARCHAR2(100),
                         RESPONDENT_CITY VARCHAR2(100),
                         RESPONDENT_STATE VARCHAR2(2),
                         RESPONDENT_ZIPCODE VARCHAR2(5),
                         RESPONDENT_PHONE_NUM VARCHAR2(14),
                         RESPONDENT_GENDER VARCHAR2(1),
                         RESPONDENT_DOB DATE,
                         CANDYBAR_ID NUMBER,
                         CANDYBAR_NAME VARCHAR2(50),
                         CANDYBAR_MFR_ID NUMBER,
                         CANDYBAR_MFR_NAME VARCHAR2(50),
                         CANDYBAR_WEIGHT_OZ NUMBER,
                         SURVEY_DATE DATE,
                         SURVEY_YEAR NUMBER,
                         TASTE_RATING NUMBER,
                         APPEARANCE_RATING NUMBER,
                         TEXTURE_RATING NUMBER,
                         OVERALL_RATING NUMBER,
                         LIKELIHOOD_PURCHASE NUMBER,
                         NBR_BARS_CONSUMED NUMBER);