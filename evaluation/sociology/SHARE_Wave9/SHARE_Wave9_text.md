# SHARE_Wave9

- **source**: SHARE_Wave9.pdf
- **model**: us.anthropic.claude-sonnet-4-6
- **dpi**: 150
- **pages**: 140

--- page 1 ---

Expand All

        IF (SampID = FirstTime)
        ⊟

            SuccesfullyInstalled
            The questionnaire was succesfully installed and initialized. Please close the interview.; <button>
            1. Continue

ELSE
⊟

            IF ((XT_Active = Empty OR (XT_Active = 0))
            ⊟

                DN801_Intro (INTRO DEMOGRAPHICS)
                Some time ago we sent you an invitation letter which also included a data protection statement. I will now give you this statement again and
                will be pleased to answer any question that you may have.

                Let me stress that participating in this interview is voluntary and that the information is kept confidential. Your answers will be used only for
                research purposes in different analyses, without the individual researcher knowing your identity. If we should come to any question you don't
                want to answer, just let me know and I will go on to the next question.
                Do you agree to participate in this study?
                Hand out the statement to R. Answer all questions of the R.
                1. Data protection statement has been provided; Respondent has consented to participate.
                2. Data protection statement has been provided; Respondent has refused to participate. No interview possible.

                  IF (DN801_Intro = a2)
                  ⊟

                      DN803_AreYouSure (SURE REFUSE TO PARTICIPATE)

                      Are you sure that Respondent has refused to participate?
                      1. Yes, R refused. Terminate interview.
                      2. No, R consented. Continue interview.

                ENDIF
                IF (DN801_Intro = a1)
                ⊟

                    DN001b_Intro (INTRO DEMOGRAPHICS B)
                    I would like to begin by asking some questions about your background.
                    1. Continue

                DN042_Gender (MALE OR FEMALE)
                  OBSERVATION
                  Note sex of respondent from observation (ask if unsure)
                  1. Male
                  2. Female

                DN043_BirthConf (CONFIRM MONTH/YEAR BIRTH)
                  Can I just confirm? You were born in Fill; ^FLYearFill;?
                  1. Yes
                  5. No

                  IF (DN043_BirthConf = a5)
                  ⊟

                      DN802_INTRObirth (INTRO BIRTH)
                          In which month and year were you born?
                          1. Continue

                ENDIF
                IF (DN043_BirthConf = a1)
                ⊟
                ELSE
                ⊟

                        IF (DN043_BirthConf = a5)
                        ⊟

                                DN002_MoBirth (MONTH OF BIRTH)
                                MONTH:
                                  1. January
                                  2. February
                                  3. March
                                  4. April
                                  5. May
                                  6. June
                                  7. July
                                  8. August
                                  9. September
                                  10. October
                                  11. November
                                  12. December

                                DN003_YearBirth (YEAR OF BIRTH)
                                YEAR:
                                NUMBER [1900..2024]

                        ENDIF
                ENDIF
                IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
                ⊟

                    DN004_CountryOfBirth (COUNTRY OF BIRTH)
                        Were you born in the United Kingdom?
                        1. Yes

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 2 ---

5. No

  IF (DN004_CountryOfBirth = a5)
  ⊟
       DN005_OtherCountry (OTHER COUNTRY OF BIRTH)
       In which country were you born? Please name the country that your birthplace belonged to at the time of your birth.
       STRING

       DN006_YearToCountry (YEAR CAME TO LIVE IN COUNTRY)
       In which year did you come to live in the United Kingdom?
       NUMBER [1875..2024]

  ENDIF
DN007_Citizenship (CITIZENSHIP COUNTRY)
  Do you have British citizenship?
  1. Yes
  5. No

  IF (DN007_Citizenship = a1)
  ⊟
       DN503_NationalitySinceBirth (NATIONALTIY SINCE BIRTH)
         Were you born a citizen of Britain?
         1. Yes
         5. No

         IF (DN503_NationalitySinceBirth = a5)
         ⊟
              DN502_WhenBecomeCitizen (WHEN CITIZEN)
                In what year did you become a citizen of Britain?
                NUMBER [1900..2024]

         ENDIF
  ELSE
  ⊟
         IF (DN007_Citizenship = a5)
         ⊟
              DN008_OtherCitizenship (OTHER CITIZENSHIP)
                What is your citizenship?
                STRING

         ENDIF
  ENDIF
  IF (((((MN001_Country = a1 OR (MN001_Country = a3) OR (MN001_Country = a8) OR (MN001_Country = a19) OR
(MN001_Country = a22))
  ⊟
       DN009_WhereLived (WHERE LIVED SINCE 1989)
       Where did you live on November 1st 1989, that is before the Berlin wall came down - Did you live in the GDR, in the FRG,
       or elsewhere?
       1. GDR
       2. FRG
       3. Elsewhere

  ENDIF
DN504_CountryOfBirthMother (COUNTRY BIRTH MOTHER)
  In which country was your mother born?
  STRING

DN505_CountryOfBirthFather (COUNTRY BIRTH FATHER)
  In which country was your father born?
  STRING

DN010_HighestEdu (HIGHEST EDUCATIONAL DEGREE OBTAINED)
  Please look at card 1.
  What is the highest school leaving certificate or school degree that you have obtained?
  If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if they
  cannot, please use the "other" option and type it in (next screen).
  1. No schooling/education at all
  2. Some education, but less than [instead of put respective country specific degr.]
  3. Country specific category
  4. Country specific category
  5. Country specific category
  6. Country specific category
  7. Country specific category
  8. Country specific category
  9. Country specific category
  10. Country specific category
  11. Country specific category
  12. Country specific category
  13. Country specific category
  14. Country specific category
  15. Country specific category
  16. Country specific category
  17. Country specific category
  18. Country specific category
  19. Country specific category
  20. Country specific category
  95. No degree yet/still in school
  97. Other

  IF (DN010_HighestEdu = a97)
  ⊟
  ,

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 3 ---

DN011_OtherHighestEdu (OTHER HIGHEST EDUCATION)
            What other school leaving certificate or school degree have you obtained?
            STRING

   ENDIF
DN012_FurtherEdu (FURTHER EDUCATION)
   Please look at card 2.
   Which degrees of higher education or vocational training do you have?
   Code all that apply.;
   If respondent answers 'still in education/vocational training' please ask if he/she already holds one of the other degrees on the
   showcard.
   SET OF 1. No higher education/vocational training
   2. Some education, but less than [instead of put respective country specific degr.]
   3. Country specific category
   4. Country specific category
   5. Country specific category
   6. Country specific category
   7. Country specific category
   8. Country specific category
   9. Country specific category
   10. Country specific category
   11. Country specific category
   12. Country specific category
   13. Country specific category
   14. Country specific category
   15. Country specific category
   16. Country specific category
   17. Country specific category
   18. Country specific category
   19. Country specific category
   20. Country specific category
   95. Still in education/vocational training
   97. Other

   IF ((97 IN (DN012_FurtherEdu))
   ⊟
         DN013_WhichOtherEdu (OTHER EDUCATION)
         Which other degree of higher education or vocational training do you have?
         STRING

   ENDIF
DN041_YearsEdu (YEARS EDUCATION)
   How many years have you been in full-time education?
   full-time education
   * includes: receiving tuition, engaging in practical work or supervised study or taking examinations
   * excludes: full-time working, home schooling, distance learning, special on-the-job training, evening classes, part-time private
   vocational training, flexible or part-time higher education studies, etc
   NUMBER [0..25]

ELSE
⊟
      IF (MN101_Longitudinal = 1)
      ⊟
            DN044_MaritalStatus (MARITAL STATUS CHANGED)
            Since our last interview, has your marital status changed?
            1. Yes, marital status has changed
            5. No, marital status has not changed

         ENDIF
ENDIF
IF (((MN101_Longitudinal = 1 AND (DN044_MaritalStatus = a1) OR ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty)))
⊟
   DN014_MaritalStatus (MARITAL STATUS)
   Please look at card 3.
   What is your marital status?
   If marriage persists but partner does not live in household for any reason, such as being in a nursing home, hospital, prison etc.,
   then code 3.
   1. Married and living together with spouse
   2. Registered partnership
   3. Married, living separated from spouse
   4. Never married
   5. Divorced
   6. Widowed

   IF (DN014_MaritalStatus = a1)
   ⊟
         IF (MN026_FirstResp = 1)
         ⊟
               DN015_YearOfMarriage (YEAR OF MARRIAGE)
               In which year did you get married?
               NUMBER [1905..2024]

               IF (DN015_YearOfMarriage = RESPONSE)
               ⊟
                     CHECK: ( YEAR(CURRENTDATE) - DN015_YearOfMarriage < MN808_AgeRespondent - 12) [Year marriage
                     should be at least 12 years after year of birth of respondent! If year is correct, please press "suppress" and
                     enter a remark to explain;]
                  ENDIF
            ENDIF
      ELSE

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 4 ---

IF (DN014_MaritalStatus = a2)
        ⊟
             DN016_YearOfPartnership (YEAR of REGISTERED PARTNERSHIP)
             In which year did you register your partnership?
             NUMBER [1905..2024]

        ELSE
        ⊟
                IF (DN014_MaritalStatus = a3)
                ⊟
                     DN017_YearOfMarriage (YEAR OF MARRIAGE)
                     In which year did you get married?
                     NUMBER [1905..2024]

                ELSE
                ⊟
                        IF (DN014_MaritalStatus = a5)
                        ⊟
                             DN018_DivorcedSinceWhen (SINCE WHEN DIVORCED)
                             In which year did you get divorced?
                             If more than one divorce enter year of last divorce

                        ELSE
                        ⊟
                                IF (DN014_MaritalStatus = a6)
                                ⊟
                                     DN019_WidowedSinceWhen (SINCE WHEN WIDOWED)
                                     In which year did you become a[widow/ widower]?
                                     Enter year of death of partner

                                ENDIF
                        ENDIF
                ENDIF
        ENDIF
ENDIF
IF (((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty) AND (((DN014_MaritalStatus = a3 OR (DN014_MaritalStatus
= a5) OR (DN014_MaritalStatus = a6)))
⊟
     DN020_AgePart (AGE OF PARTNER)
     In which year was[your][ex-/ late][husband/ wife] born?
     Record birthyear of most recent spouse
     NUMBER [1895..2009]

     DN021_HighestEduPart (HIGHEST EDUCATIONAL DEGREE OF PARTNER)
     Please look at card 1.
     What is the highest school certificate or degree that[your][ex-/ late][husband/ wife] has obtained?
     If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if
     they cannot, please use the "other" option and type it in (next screen).
     1. No schooling/education at all
     2. Some education, but less than [instead of put respective country specific degr.]
     3. Country specific category
     4. Country specific category
     5. Country specific category
     6. Country specific category
     7. Country specific category
     8. Country specific category
     9. Country specific category
     10. Country specific category
     11. Country specific category
     12. Country specific category
     13. Country specific category
     14. Country specific category
     15. Country specific category
     16. Country specific category
     17. Country specific category
     18. Country specific category
     19. Country specific category
     20. Country specific category
     95. No degree yet/still in school
     97. Other

      IF (DN021_HighestEduPart = a97)
      ⊟
           DN022_OtherHighestEduPart (OTHER HIGHEST EDUCATIONAL DEGREE PARTNER OBTAINED)
           Which other school certificate or degree has[your][ex-/ late][husband/ wife] obtained?
           STRING

     ENDIF
     DN023_FurtherEduPart (FURTHER EDUCATION OR VOCATIONAL TRAINING OBTAINED OF PARTNER)
     Please look at card 2.
     Which degrees of higher education or vocational training does[your][ex-/ late][husband/ wife] have?
     Code all that apply.;
     SET OF 1. No higher education/vocational training
     2. Some education, but less than [instead of put respective country specific degr.]
     3. Country specific category
     4. Country specific category
     5. Country specific category
     6. Country specific category

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 5 ---

7. Country specific category
                    8. Country specific category
                    9. Country specific category
                    10. Country specific category
                    11. Country specific category
                    12. Country specific category
                    13. Country specific category
                    14. Country specific category
                    15. Country specific category
                    16. Country specific category
                    17. Country specific category
                    18. Country specific category
                    19. Country specific category
                    20. Country specific category
                    95. Still in education/vocational training
                    97. Other

                     IF ((97 IN (DN023_FurtherEduPart))
                    ⊟

                         DN024_WhichOtherEduPart (OTHER EDUCATION PARTNER)
                              Which other higher education or vocational training does[your][ex-/ late][husband/ wife] have?
                              STRING

                     ENDIF
                ENDIF
        ENDIF
        IF (MN005_ModeQues = a1)
        ⊟
             DN040_PartnerOutsideHH (PARTNER OUTSIDE HOUSEHOLD)
                Do you have a partner who lives outside this household?
                1. Yes
                5. No

        ENDIF
        DN038_IntCheck (INTERVIEWER CHECK DN)

        CHECK: Who answered the questions in this section?
        1. Respondent only
        2. Respondent and proxy
        3. Proxy only

ENDIF
IF (Sec_DN1.DN801_Intro = a1)
⊟

        IF (((SN IN (Test) OR ((ALL IN (Test)))
        ⊟

                IF (MN030_socnet = 1)
                ⊟
                     SN014_Privacy (INTRODUCTION PRIVACY SN)

                     The following set of questions should be answered by the respondent in private. If there are any other persons in the
                     room at this point, please remind them that parts of the interview are of a private nature and should be answered by
                     each respondent on his or her own.
                     Start of a non-proxy section. If the respondent is not capable of answering any of these question on her/his own, press
                     CTRL-K at each question.
                     1. No need to explain, respondent is interviewed in private
                     2. Explained private nature of the interview to third persons, left the room
                     3. Explained private nature of the interview to third persons, did not leave the room

                      IF (SN014_Privacy = RESPONSE)
                     ⊟
                          SN001_Introduction (INTRODUCTION SN)
                            Now I am going to ask some questions about your relationships with other people. Most people discuss with others
                            the good or bad things that happen to them, problems they are having, or important concerns they may have.
                            Looking back over the last 12 months, who are the people with whom you most often discussed important things?
                            These people may include your family members, friends, neighbors, or other acquaintances. Please refer to these
                            people by their first names.
                            1. Continue

                            IF (SN001_Introduction = Refusal)
                            ⊟
                            ELSE
                            ⊟
                                    LOOP cnt := 1 TO 6
                                    ⊟
                                            IF ((cnt > 1 AND ([cnt - 1].SN002a_NoMore = a5))
                                            ⊟
                                            ELSE
                                            ⊟
                                                    IF (piIndex = 7)
                                                    ⊟
                                                    ELSE
                                                    ⊟
                                                            IF (piIndex = 1)
                                                            ⊟
                                                            ELSE
                                                            ⊟

--- page 6 ---

SN002a_NoMore (Any more)
                        Are there any other people (with whom you often discuss things that are
                        important to you)?
                        Click '1. Yes' immediately when it is obvious there are others
                        1. Yes
                        5. No

                ENDIF
            ENDIF
            IF (SN002a_NoMore = a1)
            ⊟
                    IF (piIndex = 7)
                    ⊟
                    ELSE
                    ⊟
                        SN002_Roster (FIRST NAME OF ROSTER N)
                            Please give me the first name of the person with whom you [MOST OFTEN/ often]
                            discuss things that are important to you:
                            [if R cannot name any network member, type 991]
                            STRING

                    ENDIF
                    IF (((SN002_Roster = Refusal OR (SN002_Roster = DontKnow) OR (SN002_Roster =
            991))
                    ⊟
                    ELSE
                    ⊟
                        SN005_NetworkRelationship (NETWORK RELATIONSHIP)
                            What is ^SN002_Roster;'s relationship to you?
                            Prompt if needed: so this person is your...
                            1. Spouse/Partner
                            2. Mother
                            3. Father
                            4. Mother-in-law
                            5. Father-in-law
                            6. Stepmother
                            7. Stepfather
                            8. Brother
                            9. Sister
                            10. Child
                            11. Step-child/your current partner's child
                            12. Son-in-law
                            13. Daughter-in-law
                            14. Grandchild
                            15. Grandparent
                            16. Aunt
                            17. Uncle
                            18. Niece
                            19. Nephew
                            20. Other relative
                            21. Friend
                            22. (Ex-)colleague/co-worker
                            23. Neighbour
                            24. Ex-spouse/partner
                            25. Minister, priest, or other clergy
                            26. Therapist or other professional helper
                            27. Housekeeper/Home health care provider
                            96. None of these

                    ENDIF
            [cnt]
            ENDIF
        ENDLOOP
        SN003a_AnyoneElse (ANY MORE)
        Is there anyone (else) who is very important to you for some other reason?
        1. Yes
        5. No

        IF (SN003a_AnyoneElse = a1)
        ⊟
            SN003_AnyoneElse (FIRST NAME OF ROSTER 7)
            Please give me the first name of a person who is important to you for some other reason.
            STRING

            IF (SN003_AnyoneElse = RESPONSE)
            ⊟
                    IF (piIndex = 7)
                    ⊟
                    ELSE
                    ⊟
                            IF (piIndex = 1)
                            ⊟
                            ELSE
                            ⊟
                                SN002a_NoMore (Any more)
                                    Are there any other people (with whom you often discuss things that are
                                    important to you)?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 7 ---

Click '1. Yes' immediately when it is obvious there are others
                        1. Yes
                        5. No

                  ENDIF
            ENDIF
            IF (SN002a_NoMore = a1)
            ⊟
                  IF (piIndex = 7)
                  ⊟
                  ELSE
                  ⊟
                        SN002_Roster (FIRST NAME OF ROSTER N)
                        Please give me the first name of the person with whom you [MOST OFTEN/ often]
                        discuss things that are important to you:
                        [if R cannot name any network member, type 991]
                        STRING

                  ENDIF
                  IF (((SN002_Roster = Refusal OR (SN002_Roster = DontKnow) OR (SN002_Roster =
            991))
                  ⊟
                  ELSE
                  ⊟
                        SN005_NetworkRelationship (NETWORK RELATIONSHIP)
                        What is ^SN002_Roster;'s relationship to you?
                        Prompt if needed: so this person is your...
                        1. Spouse/Partner
                        2. Mother
                        3. Father
                        4. Mother-in-law
                        5. Father-in-law
                        6. Stepmother
                        7. Stepfather
                        8. Brother
                        9. Sister
                        10. Child
                        11. Step-child/your current partner's child
                        12. Son-in-law
                        13. Daughter-in-law
                        14. Grandchild
                        15. Grandparent
                        16. Aunt
                        17. Uncle
                        18. Niece
                        19. Nephew
                        20. Other relative
                        21. Friend
                        22. (Ex-)colleague/co-worker
                        23. Neighbour
                        24. Ex-spouse/partner
                        25. Minister, priest, or other clergy
                        26. Therapist or other professional helper
                        27. Housekeeper/Home health care provider
                        96. None of these

                  ENDIF
            ENDIF
            [7]
            ENDIF
      ENDIF
      IF (Sizeofsocialnetwork > 0)
      ⊟
            SN008_Intro_closeness (INTRODUCTION CLOSENESS)
            Now I would like to ask a few more questions about the people who are close to you.
            1. Continue

            LOOP cnt := 1 TO 7
            ⊟
                  IF (NOT((((SN_Roster[cnt].SN002_Roster = DontKnow OR (SN_Roster[cnt].SN002_Roster =
            Refusal) OR (SN_Roster[cnt].SN002_Roster = Empty) OR (SN_Roster[cnt].SN002_Roster =
            991)))
                  ⊟
                        IF (FLRosterName <> Empty)
                        ⊟
                              IF ((FLRosterRelation = a10 OR (FLRosterRelation = a11))
                              ⊟
                                    IF (MN006_NumFamR <> 1)
                                    ⊟
                                          IF (num_of_preloadchildren > 0)
                                          ⊟
                                                SN018_PreloadMatch (LINK TO PRELOAD CHILD)
                                                You just mentioned your child ^FLRosterName;. I would like
                                                to confirm if this child was mentioned by your partner or in a
                                                previous interview.
                                                Tick the child if available in the list
                                                ^PreloadChild[1];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 8 ---

^PreloadChild[2];
                        ^PreloadChild[3];
                        ^PreloadChild[4];
                        ^PreloadChild[5];
                        ^PreloadChild[6];
                        ^PreloadChild[7];
                        ^PreloadChild[8];
                        ^PreloadChild[9];
                        ^PreloadChild[10];
                        ^PreloadChild[11];
                        ^PreloadChild[12];
                        ^PreloadChild[13];
                        ^PreloadChild[14];
                        ^PreloadChild[15];
                        ^PreloadChild[16];
                        ^PreloadChild[17];
                        ^PreloadChild[18];
                        ^PreloadChild[19];
                        ^PreloadChild[20];
                        96. Another child;

                        IF ((SN018_PreloadMatch = RESPONSE AND
                        (SN018_PreloadMatch <> a96))
                          ⊟
                          ELSE
                          ⊟
                              SN005a_Gender (NETWORK PERSON GENDER)

                                Code sex of ^FLRosterName; ^localRelationText;
                                1. Male
                                2. Female

                              SN006_NetworkProximity (NETWORK Proximity)
                                Please look at card 4
                                Where does ^FLRosterName; ^localRelationText; live?
                                1. In the same household
                                2. In the same building
                                3. Less than 1 kilometre away
                                4. Between 1 and 5 kilometres away
                                5. Between 5 and 25 kilometres away
                                6. Between 25 and 100 kilometres away
                                7. Between 100 and 500 kilometres away
                                8. More than 500 kilometres away

                          ENDIF
                        ELSE
                        ⊟
                            SN005a_Gender (NETWORK PERSON GENDER)

                              Code sex of ^FLRosterName; ^localRelationText;
                              1. Male
                              2. Female

                            SN006_NetworkProximity (NETWORK Proximity)
                              Please look at card 4
                              Where does ^FLRosterName; ^localRelationText; live?
                              1. In the same household
                              2. In the same building
                              3. Less than 1 kilometre away
                              4. Between 1 and 5 kilometres away
                              5. Between 5 and 25 kilometres away
                              6. Between 25 and 100 kilometres away
                              7. Between 100 and 500 kilometres away
                              8. More than 500 kilometres away

                        ENDIF
                      ELSE
                      ⊟
                          SN006_NetworkProximity (NETWORK Proximity)
                            Please look at card 4
                            Where does ^FLRosterName; ^localRelationText; live?
                            1. In the same household
                            2. In the same building
                            3. Less than 1 kilometre away
                            4. Between 1 and 5 kilometres away
                            5. Between 5 and 25 kilometres away
                            6. Between 25 and 100 kilometres away
                            7. Between 100 and 500 kilometres away
                            8. More than 500 kilometres away

                      ENDIF
                ELSE
                ⊟
                      IF ((FLRosterRelation = a1 AND ((MN002_Person[1].MaritalStatus = a1
                      OR (MN002_Person[1].MaritalStatus = a2)))
                        ⊟
                        ELSE
                        ⊟
                              IF ((((((FLRosterRelation = a3 OR (FLRosterRelation = a5) OR
                              (FLRosterRelation = a7) OR (FLRosterRelation = a8) OR

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 9 ---

(FLRosterRelation = a12) OR (FLRosterRelation = a17) OR
(FLRosterRelation = a19))
   ___ 
   ELSE
   ___ 
         IF (((((((FLRosterRelation = a2 OR (FLRosterRelation = a4)
         OR (FLRosterRelation = a6) OR (FLRosterRelation = a9) OR
         (FLRosterRelation = a13) OR (FLRosterRelation = a16) OR
         (FLRosterRelation = a18))
            ___ 
            ELSE
            ___ 
                  SN005a_Gender (NETWORK PERSON GENDER)

                     Code sex of ^FLRosterName; ^localRelationText;
                     1. Male
                     2. Female

                  ENDIF
         ENDIF
         IF (NOT((FLRosterRelation = a2 OR (FLRosterRelation = a3)))
         ___ 
               SN006_NetworkProximity (NETWORK Proximity)
               Please look at card 4
               Where does ^FLRosterName; ^localRelationText; live?
               1. In the same household
               2. In the same building
               3. Less than 1 kilometre away
               4. Between 1 and 5 kilometres away
               5. Between 5 and 25 kilometres away
               6. Between 25 and 100 kilometres away
               7. Between 100 and 500 kilometres away
               8. More than 500 kilometres away

         ENDIF
      ENDIF
ENDIF
IF (NOT((FLRosterRelation = a2 OR (FLRosterRelation = a3)))
___ 
      IF (NOT(SN006_NetworkProximity = a1))
      ___ 
            SN007_NetworkContact (NETWORK CONTACT)
            During the past twelve months, how often did you have contact with
            ^FLRosterName; ^localRelationText; either in person, by phone or
            mail, email or any other electronic means?
            1. Daily
            2. Several times a week
            3. About once a week
            4. About every two weeks
            5. About once a month
            6. Less than once a month
            7. Never

      ENDIF
ENDIF
SN009_Network_Closeness (Network Closeness)
How close do you feel to ^FLRosterName; ^localRelationText;?
Read out.;
1. Not very close
2. Somewhat close
3. Very close
4. Extremely close

IF (FLRosterRelation = a1)
___ 
      IF (MN005_ModeQues = a1)
      ___ 
            SN027_YearOfBirthSNMember (YEAR OF BIRTH SN MEMBER)
            In which year was ^FLRosterName; ^localRelationText; born?
            If respondent does not know the exact year of birth, ask for an
            estimate
            NUMBER [1875..2024]

      ENDIF
ELSE
___ 
      IF (NOT((FLRosterRelation = a10 OR (FLRosterRelation = a11)))
      ___ 
            SN027_YearOfBirthSNMember (YEAR OF BIRTH SN MEMBER)
            In which year was ^FLRosterName; ^localRelationText; born?
            If respondent does not know the exact year of birth, ask for an
            estimate
            NUMBER [1875..2024]

      ELSE
      ___ 
            IF (((FLRosterRelation = a10 OR (FLRosterRelation = a11) AND

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 10 ---

(MN006_NumFamR <> 1))
                              ⊟
                                    IF ((SN018_PreloadMatch = RESPONSE AND
                                   (SN018_PreloadMatch <> a96))
                                          ⊟
                                    ELSE
                                          ⊟
                                          SN027_YearOfBirthSNMember (YEAR OF BIRTH SN
                                          MEMBER)
                                            In which year was ^FLRosterName;
                                            ^localRelationText; born?
                                            If respondent does not know the exact year of birth,
                                            ask for an estimate
                                            NUMBER [1875..2024]

                                    ENDIF
                              ENDIF
                        ENDIF
                  ENDIF
            [cnt]
            ENDIF
      ENDLOOP
ENDIF
IF (Sizeofsocialnetwork = 0)
⊟
      SN017_Network_Satisfaction (EMPTY NETWORK SATISFACTION)
        You indicated that there is no one with whom you discuss important matters, and no one who is
        important to you for some other reason. On a scale from 0-10, where 0 means completely dissatisfied
        and 10 means completely satisfied, how satisfied are you with this (situation)?
        NUMBER [0..10]

ELSE
⊟
      SN012_Network_Satisfaction (NETWORK SATISFACTION)
        Overall, on a scale from 0 to 10, where 0 means completely dissatisfied and 10 means completely
        satisfied, how satisfied are you with the [relationship that you have with the person/ relationships
        that you have with all the people] we have just talked about?
        NUMBER [0..10]

      ENDIF
ENDIF
LOOP X := 1 TO 14
⊟
      IF ((pName[X] <> Empty AND (pName[X] <> ))
      ⊟
            IF (NOT((((((((((((((FL_Unmatched_NEW_SN_ANSWER[1] = Empty AND
            (FL_Unmatched_NEW_SN_ANSWER[2] = Empty) AND (FL_Unmatched_NEW_SN_ANSWER[3] = Empty)
            AND (FL_Unmatched_NEW_SN_ANSWER[4] = Empty) AND (FL_Unmatched_NEW_SN_ANSWER[5] =
            Empty) AND (FL_Unmatched_NEW_SN_ANSWER[6] = Empty) AND
            (FL_Unmatched_NEW_SN_ANSWER[7] = Empty) AND (FL_Unmatched_NEW_SN_ANSWER[8] = Empty)
            AND (FL_Unmatched_NEW_SN_ANSWER[9] = Empty) AND (FL_Unmatched_NEW_SN_ANSWER[10] =
            Empty) AND (FL_Unmatched_NEW_SN_ANSWER[11] = Empty) AND
            (FL_Unmatched_NEW_SN_ANSWER[12] = Empty) AND (FL_Unmatched_NEW_SN_ANSWER[13] =
            Empty) AND (FL_Unmatched_NEW_SN_ANSWER[14] = Empty)))
            ⊟
                  THIS_INTERVIEW (Link to)
                    [As you may remember, in a previous interview you also mentioned some people that were
                    important to you at that time.][Now we would like to compare those persons to the ones you
                    just mentioned today to find out who you mentioned again and who not.]

                    In a previous interview you mentioned ^piName; ^piRelation;. Did you mention him/her
                    again today?
                    If respondent confirms that ^piName; was mentioned today, check FIRST list below for
                    ^piName; and enter the corresponding number.
                    If ^piName; was not mentioned today, enter 96 (Person not mentioned again this time).

                    Persons mentioned this time:
                    ^FL_Unmatched_NEW_SN_ANSWER[1];
                    ^FL_Unmatched_NEW_SN_ANSWER[2];
                    ^FL_Unmatched_NEW_SN_ANSWER[3];
                    ^FL_Unmatched_NEW_SN_ANSWER[4];
                    ^FL_Unmatched_NEW_SN_ANSWER[5];
                    ^FL_Unmatched_NEW_SN_ANSWER[6];
                    ^FL_Unmatched_NEW_SN_ANSWER[7];
                    96. Person not mentioned again this time;

                    IF ((THIS_INTERVIEW = RESPONSE AND (THIS_INTERVIEW <> a96))
                    ⊟
                          IF (piRelation <> TempRelationshipString)
                          ⊟
                                SN840_Confirm (Confirm mismatched relation)
                                  The relationship you reported earlier with ^piName; ^piRelation; is different than
                                  the relationship you reported this time ^TempRelationshipString;. Is this the
                                  same person?
                                  If the respondent says that ^piName; was wrongly linked, please go back by
                                  using the arrow-left key and correct your answer.
                                  1. Yes, same person

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 11 ---

| *ENDIF*
         *ELSE*
         ⊟
              *IF (THIS_INTERVIEW = a96)*
              ⊟
                   **SN023_whathappnd** (What happened)
                     ^FL_SN023_2;^FL_SN023_3; What is the main reason you didn't mention
                     **^piName;** ^piRelation; this time?
                     1. I forgot, ^piName; should have been included
                     2. I moved
                     3. ^piName; moved
                     4. ^piName; died
                     5. I became ill or had a health problem
                     6. ^piName; became ill or had a health problem
                     7. Respondent does not recognize the named person
                     8. We are no longer close
                     9. Wrong, ^piName; WAS mentioned this time
                     97. Other reason

                     **CHECK**: (NOT((SN023_whathappnd = a9 AND (THIS_INTERVIEW = a96))) *[Please go back to the previous question and link this person correctly._start; ^piName; Please go back to the previous question and link this person correctly._end;]*
              *ENDIF*
         *ENDIF*
         *ELSE*
         ⊟
              **SN023_whathappnd** (What happened)
                ^FL_SN023_2;^FL_SN023_3; What is the main reason you didn't mention **^piName;**
                ^piRelation; this time?
                1. I forgot, ^piName; should have been included
                2. I moved
                3. ^piName; moved
                4. ^piName; died
                5. I became ill or had a health problem
                6. ^piName; became ill or had a health problem
                7. Respondent does not recognize the named person
                8. We are no longer close
                9. Wrong, ^piName; WAS mentioned this time
                97. Other reason

         *ENDIF*
         [X]
         *ENDIF*
    *ENDLOOP*
    **SN015_Who_present** (WHO WAS PRESENT)

      Check who was present during this section.
      Code all that apply.;
      1. Respondent alone
      2. Partner present
      3. Child(ren) present
      4. Other(s)

      **CHECK**: (NOT((count(SN015_Who_present) > 1 AND ((a1 IN (SN015_Who_present)))) *[Cannot select -respondent alone- with any other category;]*
    *ENDIF*
    **SN841_EndNonProxy** (WHO ANSWERED THE QUESTIONS IN SN)

      CHECK: Who answered the questions in this section?
      1. Respondent
      2. Section not answered (proxy interview)

    *ENDIF*
*ENDIF*
**DN888_IntroductionDNTwo** ()
  Now I will ask some more questions about your background.
  1. Continue

  *IF ((Preload.PRELOAD_DN026_NaturalParentAlive[1] <> a5 OR (Sec_SN.SN903_FatherInSocialNetwork = 1))*
  ⊟
       *IF (piParentAlive = 1)*
       ⊟
            *IF (((piIndex = 1 AND (Sec_SN.SN904_MotherInSocialNetwork = 1) OR ((piIndex = 2 AND (Sec_SN.SN903_FatherInSocialNetwork = 1))))*
            ⊟
            *ELSE*
            ⊟
                 *IF ((piIndex = 1 OR (piIndex = 2))*
                 ⊟
                      **DN026_NaturalParentAlive** (IS NATURAL PARENT STILL ALIVE)
                        Is*[your][natural][mother/ father]* still alive?
                        1. Yes
                        5. No

                        *IF (DN026_NaturalParentAlive = a5)*
                        ⊟
                             **DN127_YearOfDeathParent** (AGE OF DEATH OF PARENT)
                               In what year did *[your][mother/ father]* die?
                               |

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 12 ---

| NUMBER [1800..2024]

                        ENDIF
                        IF (DN026_NaturalParentAlive = a5)
                        ⊟
                            DN027_AgeOfDeathParent (AGE OF DEATH OF PARENT)
                              How old was[your][mother/ father] when[she/ he] died?
                              NUMBER [10..120]

                        ELSE
                        ⊟
                                IF ((DN026_NaturalParentAlive = a1 AND (MN101_Longitudinal = 0))
                                ⊟
                                    DN028_AgeOfNaturalParent (AGE OF NATURAL PARENT)
                                      How old is[your][mother/ father] now?
                                      NUMBER [40..120]

                                      IF (DN028_AgeOfNaturalParent = RESPONSE)
                                      ⊟
                                          CHECK: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) [Age should be at
                                          least ten years above respondent's age. If age is correct, please press "suppress" and
                                          enter a remark to explain;]
                                      ENDIF
                                ENDIF
                        ENDIF
                ELSE
                ⊟
                        IF (MN101_Longitudinal = 0)
                        ⊟
                            DN028_AgeOfNaturalParent (AGE OF NATURAL PARENT)
                              How old is[your][mother/ father] now?
                              NUMBER [40..120]

                              IF (DN028_AgeOfNaturalParent = RESPONSE)
                              ⊟
                                  CHECK: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) [Age should be at least ten
                                  years above respondent's age. If age is correct, please press "suppress" and enter a remark to
                                  explain;]
                              ENDIF
                        ENDIF
                ENDIF
        ENDIF
ENDIF
IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
⊟
    DN629_JobSitParent10 (JOB SITUATION OF PARENT 10)
    Please look at card 5. In general, which of the following best describes [your][mother/ father]'s employment situation
    when you were about 10 years old?
    1. Retired
    2. Employed or self-employed (including working for family business)
    3. Unemployed
    4. Permanently sick or disabled
    5. Homemaker
    97. Other

      IF (DN629_JobSitParent10 = a2)
      ⊟
          DN029_JobOfParent10 (NAME OR TITLE OF JOB OF PARENT)
          What was the job[your][mother/ father] had when you were about 10 years old? Please give the exact name or
          title.
          STRING

          IF (NOT(DN029_JobOfParent10 = Refusal))
          ⊟
              DN029c_JobOfParent10Code (JOBCODER - NAME OR TITLE OF JOB)
              I will now search for this job title among official jobs titles in our database.
              Re-type the job title and select the best match from the drop-down list. Please, check for spelling mistakes.
              If you navigate or scroll down, you will find more job titles.
              If you don't find the job title, ask the R to think of a different name for the job or to give a broader or a
              more specific job description.
              If you cannot find any good match at all, type 991.
              STRING

              JOBCODER: InDataOccupations
                IF ((NOT(DN029c_JobOfParent10Code = Empty) AND (NOT(DN029c_JobOfParent10Code = 991)))
                ⊟
                    DN029d_JobOfParent10Code (JOBCODER - NEXT)

                    Please verify that you selected the correct job title:
                    ^DN029c_JobOfParent10Code;
                    If this is not the correct job title, go back and select the best match from the drop-down list.
                    1. Confirm and continue

                ENDIF
          ENDIF
      ENDIF
    DN051_HighestEduParent (HIGHEST EDUCATIONAL DEGREE OF PARENT)
    Please look at card 1. What is the highest school certificate or degree that[your][mother/ father] has obtained?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 13 ---

If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if
they cannot, please use the "other" option and type it in (next screen).
1. No schooling/education at all
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category
4. Country specific category
5. Country specific category
6. Country specific category
7. Country specific category
8. Country specific category
9. Country specific category
10. Country specific category
11. Country specific category
12. Country specific category
13. Country specific category
14. Country specific category
15. Country specific category
16. Country specific category
17. Country specific category
18. Country specific category
19. Country specific category
20. Country specific category
95. No degree yet/still in school
97. Other

  IF (DN051_HighestEduParent = a97)
  ⊟
      DN052_OtherHighestEduParent (OTHER HIGHEST EDUCATION PARENT)
        Which other school certificate or degree has[your][mother/ father] obtained?
        STRING

  ENDIF
DN053_FurtherEduParent (FURTHER EDUCATION OR VOCATIONAL TRAINING PARENT)
Please look at card 2. Which degrees of higher education or vocational training does[your][mother/ father] have?
Code all that apply.;
SET OF 1. No higher education/vocational training
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category
4. Country specific category
5. Country specific category
6. Country specific category
7. Country specific category
8. Country specific category
9. Country specific category
10. Country specific category
11. Country specific category
12. Country specific category
13. Country specific category
14. Country specific category
15. Country specific category
16. Country specific category
17. Country specific category
18. Country specific category
19. Country specific category
20. Country specific category
95. Still in education/vocational training
97. Other

  IF ((a97 IN (DN053_FurtherEduParent))
  ⊟
      DN054_WhichOtherEduParent (OTHER HIGHEST PARENT)
        Which other degree of higher education or vocational training has[your][mother/ father] obtained?
        STRING

  ENDIF
ENDIF
IF (piParentAlive = 1)
⊟
    IF ((piIndex = 2 OR (piIndex = 1))
    ⊟
        IF (DN026_NaturalParentAlive = a1)
        ⊟
            DN030_LivingPlaceParent (WHERE DOES PARENT LIVE)
              Please look at card 4.
              Where does[your][mother/ father] live?
              1. In the same household
              2. In the same building
              3. Less than 1 kilometre away
              4. Between 1 and 5 kilometres away
              5. Between 5 and 25 kilometres away
              6. Between 25 and 100 kilometres away
              7. Between 100 and 500 kilometres away
              8. More than 500 kilometres away

              IF (DN030_LivingPlaceParent > a1)
              ⊟
                  DN032_ContactDuringPast12Months (PERSONAL CONTACT WITH PARENT DURING PAST 12 MONTHS)
                    During the past twelve months, how often did you have contact with[your][mother/ father], either in
                    person, by phone, mail, email or any other electronic means?
                    1. Daily

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 14 ---

2. Several times a week
                    3. About once a week
                    4. About every two weeks
                    5. About once a month
                    6. Less than once a month
                    7. Never

                *ENDIF*
                **DN033_HealthParent** (HEALTH OF PARENT)
                    How would you describe the health of*[your][mother/ father]*? Would you say it is
                    Read out.;
                    1. Excellent
                    2. Very good
                    3. Good
                    4. Fair
                    5. Poor

            *ENDIF*
        *ELSE*
        ⊟
            **DN033_HealthParent** (HEALTH OF PARENT)
                How would you describe the health of*[your][mother/ father]*? Would you say it is
                Read out.;
                1. Excellent
                2. Very good
                3. Good
                4. Fair
                5. Poor

        *ENDIF*
    *ENDIF*
    [2]
*ELSE*
⊟
    *IF (piParentAlive = 1)*
    ⊟
        *IF (((piIndex = 1 AND (Sec_SN.SN904_MotherInSocialNetwork = 1) OR ((piIndex = 2 AND (Sec_SN.SN903_FatherInSocialNetwork = 1)))*
        ⊟
        *ELSE*
        ⊟
            *IF ((piIndex = 1 OR (piIndex = 2))*
            ⊟
                **DN026_NaturalParentAlive** (IS NATURAL PARENT STILL ALIVE)
                    Is*[your][natural][mother/ father]* still alive?
                    1. Yes
                    5. No

                    *IF (DN026_NaturalParentAlive = a5)*
                    ⊟
                        **DN127_YearOfDeathParent** (AGE OF DEATH OF PARENT)
                            In what year did *[your][mother/ father]* die?
                            NUMBER [1800..2024]

                    *ENDIF*
                    *IF (DN026_NaturalParentAlive = a5)*
                    ⊟
                        **DN027_AgeOfDeathParent** (AGE OF DEATH OF PARENT)
                            How old was*[your][mother/ father]* when*[she/ he]* died?
                            NUMBER [10..120]

                    *ELSE*
                    ⊟
                        *IF ((DN026_NaturalParentAlive = a1 AND (MN101_Longitudinal = 0))*
                        ⊟
                            **DN028_AgeOfNaturalParent** (AGE OF NATURAL PARENT)
                                How old is*[your][mother/ father]* now?
                                NUMBER [40..120]

                                *IF (DN028_AgeOfNaturalParent = RESPONSE)*
                                ⊟
                                    **CHECK**: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) *[Age should be at least ten years above respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]*
                                *ENDIF*
                        *ENDIF*
                    *ENDIF*
            *ELSE*
            ⊟
                *IF (MN101_Longitudinal = 0)*
                ⊟
                    **DN028_AgeOfNaturalParent** (AGE OF NATURAL PARENT)
                        How old is*[your][mother/ father]* now?
                        NUMBER [40..120]

                        *IF (DN028_AgeOfNaturalParent = RESPONSE)*
                        ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 15 ---

**CHECK**: {DN028_AgeOfNaturalParent >= MN808_AgeRespondent10} *[Age should be at least ten years above respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]*
                        *ENDIF*
                     *ENDIF*
                  *ENDIF*
               *ENDIF*
            *ENDIF*
*IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))*
⊟
   **DN629_JobSitParent10** (JOB SITUATION OF PARENT 10)
   Please look at card 5. In general, which of the following best describes *[your][mother/ father]*'s employment situation when you were about 10 years old?
   1. Retired
   2. Employed or self-employed (including working for family business)
   3. Unemployed
   4. Permanently sick or disabled
   5. Homemaker
   97. Other

   *IF (DN629_JobSitParent10 = a2)*
   ⊟
      **DN029_JobOfParent10** (NAME OR TITLE OF JOB OF PARENT)
         What was the job*[your][mother/ father]* had when you were about 10 years old? Please give the exact name or title.
         STRING

         *IF (NOT(DN029_JobOfParent10 = Refusal))*
         ⊟
            **DN029c_JobOfParent10Code** (JOBCODER - NAME OR TITLE OF JOB)
            I will now search for this job title among official jobs titles in our database.
            Re-type the job title and select the best match from the drop-down list. Please, check for spelling mistakes.
            If you navigate or scroll down, you will find more job titles.
            If you don't find the job title, ask the R to think of a different name for the job or to give a broader or a more specific job description.
            If you cannot find any good match at all, type 991.
            STRING

            **JOBCODER:** InDataOccupations
               *IF ((NOT(DN029c_JobOfParent10Code = Empty) AND (NOT(DN029c_JobOfParent10Code = 991)))*
               ⊟
                  **DN029d_JobOfParent10Code** (JOBCODER - NEXT)

                     Please verify that you selected the correct job title:
                     **^DN029c_JobOfParent10Code;**
                     If this is not the correct job title, go back and select the best match from the drop-down list.
                     1. Confirm and continue

               *ENDIF*
         *ENDIF*
   *ENDIF*
**DN051_HighestEduParent** (HIGHEST EDUCATIONAL DEGREE OF PARENT)
Please look at card 1. What is the highest school certificate or degree that*[your][mother/ father]* has obtained?
If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if they cannot, please use the "other" option and type it in (next screen).
1. No schooling/education at all
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category
4. Country specific category
5. Country specific category
6. Country specific category
7. Country specific category
8. Country specific category
9. Country specific category
10. Country specific category
11. Country specific category
12. Country specific category
13. Country specific category
14. Country specific category
15. Country specific category
16. Country specific category
17. Country specific category
18. Country specific category
19. Country specific category
20. Country specific category
95. No degree yet/still in school
97. Other

   *IF (DN051_HighestEduParent = a97)*
   ⊟
      **DN052_OtherHighestEduParent** (OTHER HIGHEST EDUCATION PARENT)
         Which other school certificate or degree has*[your][mother/ father]* obtained?
         STRING

   *ENDIF*
**DN053_FurtherEduParent** (FURTHER EDUCATION OR VOCATIONAL TRAINING PARENT)
Please look at card 2. Which degrees of higher education or vocational training does*[your][mother/ father]* have?
Code all that apply.;
SET OF 1. No higher education/vocational training
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 16 ---

4. Country specific category
                    5. Country specific category
                    6. Country specific category
                    7. Country specific category
                    8. Country specific category
                    9. Country specific category
                    10. Country specific category
                    11. Country specific category
                    12. Country specific category
                    13. Country specific category
                    14. Country specific category
                    15. Country specific category
                    16. Country specific category
                    17. Country specific category
                    18. Country specific category
                    19. Country specific category
                    20. Country specific category
                    95. Still in education/vocational training
                    97. Other

                     IF ((a97 IN (DN053_FurtherEduParent))
                    ⊟

                        DN054_WhichOtherEduParent (OTHER HIGHEST PARENT)
                        Which other degree of higher education or vocational training has[your][mother/ father] obtained?
                        STRING

                    ENDIF
               ENDIF
               IF (piParentAlive = 1)
               ⊟

                    IF ((piIndex = 2 OR (piIndex = 1))
                    ⊟

                         IF (DN026_NaturalParentAlive = a1)
                         ⊟
                              DN030_LivingPlaceParent (WHERE DOES PARENT LIVE)
                                   Please look at card 4.
                                   Where does[your][mother/ father] live?
                                   1. In the same household
                                   2. In the same building
                                   3. Less than 1 kilometre away
                                   4. Between 1 and 5 kilometres away
                                   5. Between 5 and 25 kilometres away
                                   6. Between 25 and 100 kilometres away
                                   7. Between 100 and 500 kilometres away
                                   8. More than 500 kilometres away

                                    IF (DN030_LivingPlaceParent > a1)
                                   ⊟
                                        DN032_ContactDuringPast12Months (PERSONAL CONTACT WITH PARENT DURING PAST 12 MONTHS)
                                             During the past twelve months, how often did you have contact with[your][mother/ father], either in
                                             person, by phone, mail, email or any other electronic means?
                                             1. Daily
                                             2. Several times a week
                                             3. About once a week
                                             4. About every two weeks
                                             5. About once a month
                                             6. Less than once a month
                                             7. Never

                                    ENDIF
                              DN033_HealthParent (HEALTH OF PARENT)
                                   How would you describe the health of[your][mother/ father]? Would you say it is
                                   Read out.;
                                   1. Excellent
                                   2. Very good
                                   3. Good
                                   4. Fair
                                   5. Poor

                         ENDIF
                         ELSE
                         ⊟
                              DN033_HealthParent (HEALTH OF PARENT)
                                   How would you describe the health of[your][mother/ father]? Would you say it is
                                   Read out.;
                                   1. Excellent
                                   2. Very good
                                   3. Good
                                   4. Fair
                                   5. Poor

                         ENDIF
                    ENDIF
               [2]
               ENDIF
               IF ((Preload.PRELOAD_DN026_NaturalParentAlive[2] <> a5 OR (Sec_SN.SN904_MotherInSocialNetwork = 1))
               ⊟
                    IF (piParentAlive = 1)
                    ⊟
                    |

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 17 ---

IF (((piIndex = 1 AND (Sec_SN.SN904_MotherInSocialNetwork = 1) OR ((piIndex = 2 AND
(Sec_SN.SN903_FatherInSocialNetwork = 1)))
   ⊟
   ELSE
   ⊟
         IF ((piIndex = 1 OR (piIndex = 2))
         ⊟
               DN026_NaturalParentAlive (IS NATURAL PARENT STILL ALIVE)
                  Is[your][natural][mother/ father] still alive?
                  1. Yes
                  5. No

                  IF (DN026_NaturalParentAlive = a5)
                  ⊟
                        DN127_YearOfDeathParent (AGE OF DEATH OF PARENT)
                           In what year did [your][mother/ father] die?
                           NUMBER [1800..2024]

                  ENDIF
                  IF (DN026_NaturalParentAlive = a5)
                  ⊟
                        DN027_AgeOfDeathParent (AGE OF DEATH OF PARENT)
                           How old was[your][mother/ father] when[she/ he] died?
                           NUMBER [10..120]

                  ELSE
                  ⊟
                        IF ((DN026_NaturalParentAlive = a1 AND (MN101_Longitudinal = 0))
                        ⊟
                              DN028_AgeOfNaturalParent (AGE OF NATURAL PARENT)
                                 How old is[your][mother/ father] now?
                                 NUMBER [40..120]

                                 IF (DN028_AgeOfNaturalParent = RESPONSE)
                                 ⊟
                                       CHECK: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) [Age should be at
                                       least ten years above respondent's age. If age is correct, please press "suppress" and
                                       enter a remark to explain;]
                                 ENDIF
                        ENDIF
                  ENDIF
         ELSE
         ⊟
               IF (MN101_Longitudinal = 0)
               ⊟
                     DN028_AgeOfNaturalParent (AGE OF NATURAL PARENT)
                        How old is[your][mother/ father] now?
                        NUMBER [40..120]

                        IF (DN028_AgeOfNaturalParent = RESPONSE)
                        ⊟
                              CHECK: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) [Age should be at least ten
                              years above respondent's age. If age is correct, please press "suppress" and enter a remark to
                              explain;]
                        ENDIF
               ENDIF
         ENDIF
   ENDIF
ENDIF
IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
⊟
   DN629_JobSitParent10 (JOB SITUATION OF PARENT 10)
   Please look at card 5. In general, which of the following best describes [your][mother/ father]'s employment situation
   when you were about 10 years old?
   1. Retired
   2. Employed or self-employed (including working for family business)
   3. Unemployed
   4. Permanently sick or disabled
   5. Homemaker
   97. Other

   IF (DN629_JobSitParent10 = a2)
   ⊟
         DN029_JobOfParent10 (NAME OR TITLE OF JOB OF PARENT)
            What was the job[your][mother/ father] had when you were about 10 years old? Please give the exact name or
            title.
            STRING

            IF (NOT(DN029_JobOfParent10 = Refusal))
            ⊟
                  DN029c_JobOfParent10Code (JOBCODER - NAME OR TITLE OF JOB)
                     I will now search for this job title among official jobs titles in our database.
                     Re-type the job title and select the best match from the drop-down list. Please, check for spelling mistakes.
                     If you navigate or scroll down, you will find more job titles.
                     If you don't find the job title, ask the R to think of a different name for the job or to give a broader or a
                     more specific job description.
                     If you cannot find any good match at all, type 991.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 18 ---

STRING

JOBCODER: InDataOccupations
         IF ((NOT(DN029c_JobOfParent10Code = Empty) AND (NOT(DN029c_JobOfParent10Code = 991)))
         ⊟
              DN029d_JobOfParent10Code (JOBCODER - NEXT)

                Please verify that you selected the correct job title:
                ^DN029c_JobOfParent10Code;
                If this is not the correct job title, go back and select the best match from the drop-down list.
                1. Confirm and continue

              ENDIF
         ENDIF
    ENDIF
DN051_HighestEduParent (HIGHEST EDUCATIONAL DEGREE OF PARENT)
Please look at card 1. What is the highest school certificate or degree that[your][mother/ father] has obtained?
If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if
they cannot, please use the "other" option and type it in (next screen).
1. No schooling/education at all
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category
4. Country specific category
5. Country specific category
6. Country specific category
7. Country specific category
8. Country specific category
9. Country specific category
10. Country specific category
11. Country specific category
12. Country specific category
13. Country specific category
14. Country specific category
15. Country specific category
16. Country specific category
17. Country specific category
18. Country specific category
19. Country specific category
20. Country specific category
95. No degree yet/still in school
97. Other

  IF (DN051_HighestEduParent = a97)
  ⊟
       DN052_OtherHighestEduParent (OTHER HIGHEST EDUCATION PARENT)
         Which other school certificate or degree has[your][mother/ father] obtained?
         STRING

  ENDIF
DN053_FurtherEduParent (FURTHER EDUCATION OR VOCATIONAL TRAINING PARENT)
Please look at card 2. Which degrees of higher education or vocational training does[your][mother/ father] have?
Code all that apply.;
SET OF 1. No higher education/vocational training
2. Some education, but less than [instead of put respective country specific degr.]
3. Country specific category
4. Country specific category
5. Country specific category
6. Country specific category
7. Country specific category
8. Country specific category
9. Country specific category
10. Country specific category
11. Country specific category
12. Country specific category
13. Country specific category
14. Country specific category
15. Country specific category
16. Country specific category
17. Country specific category
18. Country specific category
19. Country specific category
20. Country specific category
95. Still in education/vocational training
97. Other

  IF ((a97 IN (DN053_FurtherEduParent))
  ⊟
       DN054_WhichOtherEduParent (OTHER HIGHEST PARENT)
         Which other degree of higher education or vocational training has[your][mother/ father] obtained?
         STRING

  ENDIF
ENDIF
IF (piParentAlive = 1)
⊟
     IF ((piIndex = 2 OR (piIndex = 1))
     ⊟
          IF (DN026_NaturalParentAlive = a1)
          ⊟
               DN030_LivingPlaceParent (WHERE DOES PARENT LIVE)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 19 ---

Please look at card 4.
Where does*[your][mother/ father]* live?
1. In the same household
2. In the same building
3. Less than 1 kilometre away
4. Between 1 and 5 kilometres away
5. Between 5 and 25 kilometres away
6. Between 25 and 100 kilometres away
7. Between 100 and 500 kilometres away
8. More than 500 kilometres away

 IF (DN030_LivingPlaceParent > a1)
 ⊟
     **DN032_ContactDuringPast12Months** (PERSONAL CONTACT WITH PARENT DURING PAST 12 MONTHS)
         During the past twelve months, how often did you have contact with*[your][mother/ father]*, either in
         person, by phone, mail, email or any other electronic means?
         1. Daily
         2. Several times a week
         3. About once a week
         4. About every two weeks
         5. About once a month
         6. Less than once a month
         7. Never

 ENDIF
 **DN033_HealthParent** (HEALTH OF PARENT)
     How would you describe the health of*[your][mother/ father]*? Would you say it is
     Read out.;
     1. Excellent
     2. Very good
     3. Good
     4. Fair
     5. Poor

         ENDIF
         ELSE
         ⊟
             **DN033_HealthParent** (HEALTH OF PARENT)
             How would you describe the health of*[your][mother/ father]*? Would you say it is
             Read out.;
             1. Excellent
             2. Very good
             3. Good
             4. Fair
             5. Poor

         ENDIF
     ENDIF
     [1]
 ELSE
 ⊟
     IF (piParentAlive = 1)
     ⊟
         IF (((piIndex = 1 AND (Sec_SN.SN904_MotherInSocialNetwork = 1) OR ((piIndex = 2 AND
         (Sec_SN.SN903_FatherInSocialNetwork = 1)))
         ⊟
         ELSE
         ⊟
             IF ((piIndex = 1 OR (piIndex = 2))
             ⊟
                 **DN026_NaturalParentAlive** (IS NATURAL PARENT STILL ALIVE)
                 Is*[your][natural][mother/ father]* still alive?
                 1. Yes
                 5. No

                 IF (DN026_NaturalParentAlive = a5)
                 ⊟
                     **DN127_YearOfDeathParent** (AGE OF DEATH OF PARENT)
                     In what year did *[your][mother/ father]* die?
                     NUMBER [1800..2024]

                 ENDIF
                 IF (DN026_NaturalParentAlive = a5)
                 ⊟
                     **DN027_AgeOfDeathParent** (AGE OF DEATH OF PARENT)
                     How old was*[your][mother/ father]* when*[she/ he]* died?
                     NUMBER [10..120]

                 ELSE
                 ⊟
                     IF ((DN026_NaturalParentAlive = a1 AND (MN101_Longitudinal = 0))
                     ⊟
                         **DN028_AgeOfNaturalParent** (AGE OF NATURAL PARENT)
                         How old is*[your][mother/ father]* now?
                         NUMBER [40..120]

                         IF (DN028_AgeOfNaturalParent = RESPONSE)
                         ⊟
                         ,

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 20 ---

**CHECK**: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) *[Age should be at least ten years above respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]*
                                        *ENDIF*
                                    *ENDIF*
                        *ELSE*
                        ⊟
                            *IF (MN101_Longitudinal = 0)*
                            ⊟
                                **DN028_AgeOfNaturalParent** (AGE OF NATURAL PARENT)
                                How old is*[your][mother/ father]* now?
                                NUMBER [40..120]

                                *IF (DN028_AgeOfNaturalParent = RESPONSE)*
                                ⊟
                                    **CHECK**: (DN028_AgeOfNaturalParent >= MN808_AgeRespondent10) *[Age should be at least ten years above respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]*
                                *ENDIF*
                            *ENDIF*
                        *ENDIF*
                    *ENDIF*
        *ENDIF*
        *IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))*
        ⊟
            **DN629_JobSitParent10** (JOB SITUATION OF PARENT 10)
            Please look at card 5. In general, which of the following best describes *[your][mother/ father]*'s employment situation when you were about 10 years old?
            1. Retired
            2. Employed or self-employed (including working for family business)
            3. Unemployed
            4. Permanently sick or disabled
            5. Homemaker
            97. Other

            *IF (DN629_JobSitParent10 = a2)*
            ⊟
                **DN029_JobOfParent10** (NAME OR TITLE OF JOB OF PARENT)
                    What was the job*[your][mother/ father]* had when you were about 10 years old? Please give the exact name or title.
                    STRING

                    *IF (NOT(DN029_JobOfParent10 = Refusal))*
                    ⊟
                        **DN029c_JobOfParent10Code** (JOBCODER - NAME OR TITLE OF JOB)
                            I will now search for this job title among official jobs titles in our database.
                            Re-type the job title and select the best match from the drop-down list. Please, check for spelling mistakes.
                            If you navigate or scroll down, you will find more job titles.
                            If you don't find the job title, ask the R to think of a different name for the job or to give a broader or a more specific job description.
                            If you cannot find any good match at all, type 991.
                            STRING

                        **JOBCODER:** InDataOccupations
                            *IF ((NOT(DN029c_JobOfParent10Code = Empty) AND (NOT(DN029c_JobOfParent10Code = 991)))*
                            ⊟
                                **DN029d_JobOfParent10Code** (JOBCODER - NEXT)

                                    Please verify that you selected the correct job title:
                                    ^**DN029c_JobOfParent10Code;**
                                    If this is not the correct job title, go back and select the best match from the drop-down list.
                                    1. Confirm and continue

                            *ENDIF*
                    *ENDIF*
            *ENDIF*
        **DN051_HighestEduParent** (HIGHEST EDUCATIONAL DEGREE OF PARENT)
        Please look at card 1. What is the highest school certificate or degree that*[your][mother/ father]* has obtained?
        If respondent mentions foreign degree/certificate, please ask if he/she can fit their degree into the given categories, if they cannot, please use the "other" option and type it in (next screen).
        1. No schooling/education at all
        2. Some education, but less than [instead of put respective country specific degr.]
        3. Country specific category
        4. Country specific category
        5. Country specific category
        6. Country specific category
        7. Country specific category
        8. Country specific category
        9. Country specific category
        10. Country specific category
        11. Country specific category
        12. Country specific category
        13. Country specific category
        14. Country specific category
        15. Country specific category
        16. Country specific category
        17. Country specific category
        18. Country specific category

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 21 ---

19. Country specific category
            20. Country specific category
            95. No degree yet/still in school
            97. Other

             IF (DN051_HighestEduParent = a97)
             ⊟
                  DN052_OtherHighestEduParent (OTHER HIGHEST EDUCATION PARENT)
                    Which other school certificate or degree has[your][mother/ father] obtained?
                    STRING

             ENDIF
          DN053_FurtherEduParent (FURTHER EDUCATION OR VOCATIONAL TRAINING PARENT)
          Please look at card 2. Which degrees of higher education or vocational training does[your][mother/ father] have?
          Code all that apply.;
          SET OF 1. No higher education/vocational training
          2. Some education, but less than [instead of put respective country specific degr.]
          3. Country specific category
          4. Country specific category
          5. Country specific category
          6. Country specific category
          7. Country specific category
          8. Country specific category
          9. Country specific category
          10. Country specific category
          11. Country specific category
          12. Country specific category
          13. Country specific category
          14. Country specific category
          15. Country specific category
          16. Country specific category
          17. Country specific category
          18. Country specific category
          19. Country specific category
          20. Country specific category
          95. Still in education/vocational training
          97. Other

           IF ((a97 IN (DN053_FurtherEduParent))
           ⊟
                DN054_WhichOtherEduParent (OTHER HIGHEST PARENT)
                  Which other degree of higher education or vocational training has[your][mother/ father] obtained?
                  STRING

           ENDIF
     ENDIF
     IF (piParentAlive = 1)
     ⊟
          IF ((piIndex = 2 OR (piIndex = 1))
          ⊟
               IF (DN026_NaturalParentAlive = a1)
               ⊟
                    DN030_LivingPlaceParent (WHERE DOES PARENT LIVE)
                      Please look at card 4.
                      Where does[your][mother/ father] live?
                      1. In the same household
                      2. In the same building
                      3. Less than 1 kilometre away
                      4. Between 1 and 5 kilometres away
                      5. Between 5 and 25 kilometres away
                      6. Between 25 and 100 kilometres away
                      7. Between 100 and 500 kilometres away
                      8. More than 500 kilometres away

                       IF (DN030_LivingPlaceParent > a1)
                       ⊟
                            DN032_ContactDuringPast12Months (PERSONAL CONTACT WITH PARENT DURING PAST 12 MONTHS)
                              During the past twelve months, how often did you have contact with[your][mother/ father], either in
                              person, by phone, mail, email or any other electronic means?
                              1. Daily
                              2. Several times a week
                              3. About once a week
                              4. About every two weeks
                              5. About once a month
                              6. Less than once a month
                              7. Never

                       ENDIF
                    DN033_HealthParent (HEALTH OF PARENT)
                      How would you describe the health of[your][mother/ father]? Would you say it is
                      Read out.;
                      1. Excellent
                      2. Very good
                      3. Good
                      4. Fair
                      5. Poor

               ENDIF
          ELSE
          ⊟
               |

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 22 ---

DN033_HealthParent (HEALTH OF PARENT)
                        How would you describe the health of[your][mother/ father]? Would you say it is
                        Read out.;
                        1. Excellent
                        2. Very good
                        3. Good
                        4. Fair
                        5. Poor

                    ENDIF
                ENDIF
            [1]
        ENDIF
        IF (MN101_Longitudinal = 0)
        ⊟
            DN034_AnySiblings (EVER HAD ANY SIBLINGS)
            Have you ever had any siblings?
            Include non-biological siblings
            1. Yes
            5. No

              IF (DN034_AnySiblings = a1)
              ⊟
                  DN035_OldestYoungestBetweenChild (OLDEST YOUNGEST CHILD)
                  Talking about your siblings, were you the oldest child, the youngest child, or somewhere in-between?
                  1. Oldest
                  2. Youngest
                  3. In-between

              ENDIF
        ENDIF
        IF (((DN034_AnySiblings = a1 OR (Preload.PRELOAD_DN036_HowManyBrothersAlive > 0) OR ((MN101_Longitudinal = 1 AND
(Preload.PRELOAD_DN036_HowManyBrothersAlive = Empty)))
        ⊟
            DN036_HowManyBrothersAlive (HOW MANY BROTHERS ALIVE)
            How many brothers do you have that are still alive?
            Include non-biological
            NUMBER [0..20]

        ENDIF
        IF (((DN034_AnySiblings = a1 OR (Preload.PRELOAD_DN037_HowManySistersAlive > 0) OR ((MN101_Longitudinal = 1 AND
(Preload.PRELOAD_DN037_HowManySistersAlive = Empty)))
        ⊟
            DN037_HowManySistersAlive (HOW MANY SISTERS ALIVE)
            And how many sisters do you have that are still alive?
            Include non-biological
            NUMBER [0..20]

        ENDIF
        IF (((CH IN (Test) OR ((ALL IN (Test)))
        ⊟
              IF (MN006_NumFamR = 1)
              ⊟
                  CH001_NumberOfChildren (NUMBER OF CHILDREN)
                  Now I will ask some questions about your children. How many children do you have that are still alive? Please count all
                  natural children, fostered, adopted and stepchildren[, including those of] [your husband/ your wife/ your partner] [{Name
                  of partner/spouse}].
                  NUMBER [0..20]

                  CHECK: (NOT((Sec_SN.SN906_ChildInSocialNetwork > 0 AND ((CH001_NumberOfChildren = 0 OR
                  (CH001_NumberOfChildren = Empty)))) [You mentioned children in the Social network module, please correct.;]
                    IF (CH001_NumberOfChildren > 0)
                    ⊟
                          IF ((NOT(Preload.PreloadedChildren[1].Name = Empty) OR (Sec_SN.SN906_ChildInSocialNetwork > 0))
                          ⊟
                              CH201_ChildByINTRO (INTRO PRELOADED CHILDREN)
                              I will read a list of all children we have talked about [today/ today or in a previous interview].
                              Some of your children may be listed twice in this list, others may be missing or we may have missing or
                              wrong information for some children.

                              I would like to go through this list with you and make sure we have complete and correct information for all
                              natural children, fostered, adopted and stepchildren. We are interested in children that are still alive.
                              1. Continue

                          ELSE
                          ⊟
                              CH603_IntroTextChildren (INTRO IF NO SN OR PRELOADED CHILDREN)
                              We would like to know more about[this child/ these children. Let us begin with the oldest child]. Again,
                              please think of all natural children, fostered, adopted and stepchildren[including those of your husband/
                              including those of your wife/ including those of your partner].
                              1. Continue

                          ENDIF
                          LOOP cnt := 1 TO 20
                          ⊟
                                IF (NOT(Preload.PreloadedChildren[cnt].Kidcom = Empty))
                                ⊟
                                      IF ((piIndex <= GridSize AND ((imForwarded = 0 OR (imForwarded = Empty)))

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 23 ---

ELSE
IF (piRosterChildIndex > 0)

         CH001a_ChildCheck (CHILD CONFIRM)
            Do you have [{dynamic constructed text based on how the child was loaded}]?

            Again, please think of all natural children, fostered, adopted and stepchildren [,
            including those of] [your husband/ your wife/ your partner].
            [If a child is listed twice, delete the second one with category \"6. Yes, but already
            mentioned earlier\", and keep the first]
            Children overview:;
            1. Yes
            [2. Yes, but child's name, gender or year of birth is incorrect]
            [3. No, child of partner from whom R separated.]
            [4. No, child died]
            [5. No, child unknown/ 5. No]
            [6. Yes, but already mentioned earlier]
            [97. No, other reason]

      ELSE
         IF (piPreloadChildIndex > 0)

               CH001a_ChildCheck (CHILD CONFIRM)
                  Do you have [{dynamic constructed text based on how the child was loaded}]?

                  Again, please think of all natural children, fostered, adopted and stepchildren [,
                  including those of] [your husband/ your wife/ your partner].
                  [If a child is listed twice, delete the second one with category \"6. Yes, but
                  already mentioned earlier\", and keep the first]
                  Children overview:;
                  1. Yes
                  [2. Yes, but child's name, gender or year of birth is incorrect]
                  [3. No, child of partner from whom R separated.]
                  [4. No, child died]
                  [5. No, child unknown/ 5. No]
                  [6. Yes, but already mentioned earlier]
                  [97. No, other reason]

         ELSE

               CH001a_ChildCheck (CHILD CONFIRM)
                  Do you have [{dynamic constructed text based on how the child was loaded}]?

                  Again, please think of all natural children, fostered, adopted and stepchildren [,
                  including those of] [your husband/ your wife/ your partner].
                  [If a child is listed twice, delete the second one with category \"6. Yes, but
                  already mentioned earlier\", and keep the first]
                  Children overview:;
                  1. Yes
                  [2. Yes, but child's name, gender or year of birth is incorrect]
                  [3. No, child of partner from whom R separated.]
                  [4. No, child died]
                  [5. No, child unknown/ 5. No]
                  [6. Yes, but already mentioned earlier]
                  [97. No, other reason]

         ENDIF
      ENDIF
   ENDIF
CHECK: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex = 0 OR (piPreloadChildIndex =
Empty)))) [Child was mentioned in the social network and might therefore appear twice. Please check
and if same child is listed twice choose option 6 instead of 97;]
   IF (CH001a_ChildCheck = a1)

         IF (CH004_FirstNameOfChild = Empty)

               CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                  ^FL_CH004_5;

                  What is the {correct} first name of {this/ your next} child?
                  Please enter/confirm first name.
                  STRING

         ELSE

               CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                  ^FL_CH004_5;

                  What is the {correct} first name of {this/ your next} child?
                  Please enter/confirm first name.
                  STRING

         ENDIF
         IF (NOT(CH004_FirstNameOfChild = Empty))

               IF (CH005_SexOfChildN = Empty)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 24 ---

CH005_SexOfChildN (SEX OF CHILD N)
                Is ^CH004_FirstNameOfChild; male or female?
                Ask only if unclear.
                1. Male
                2. Female

          ELSE
            CH005_SexOfChildN (SEX OF CHILD N)
                Is ^CH004_FirstNameOfChild; male or female?
                Ask only if unclear.
                1. Male
                2. Female

          ENDIF
          IF (NOT(CH005_SexOfChildN = Empty))
            IF (CH006_YearOfBirthChildN = Empty)
                CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                    In which year was ^CH004_FirstNameOfChild; born?
                    Please enter/confirm year of birth.
                    NUMBER [1875..2024]

              ELSE
                CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                    In which year was ^CH004_FirstNameOfChild; born?
                    Please enter/confirm year of birth.
                    NUMBER [1875..2024]

            ENDIF
          ENDIF
        ENDIF
ELSE
  IF (CH001a_ChildCheck = a2)
      CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
        ^FL_CH004_5;

        What is the {correct} first name of {this/ your next} child?
        Please enter/confirm first name.
        STRING

      CH005_SexOfChildN (SEX OF CHILD N)
        Is ^CH004_FirstNameOfChild; male or female?
        Ask only if unclear.
        1. Male
        2. Female

      CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
        In which year was ^CH004_FirstNameOfChild; born?
        Please enter/confirm year of birth.
        NUMBER [1875..2024]

  ELSE
      IF (((piPreloadChildIndex > 0 OR (((piPreloadChildIndex = 0 OR (piPreloadChildIndex =
      Empty) AND (piRosterChildIndex > 0)) AND (CH001a_ChildCheck = a6))
          CH505_WhichChildMentionedEarlier (EQUAL TO WHICH CHILD)

              To which child that was already mentioned earlier is ^FL_CHILD_NAME; equal?
                ^FLChild[1];
                ^FLChild[2];
                ^FLChild[3];
                ^FLChild[4];
                ^FLChild[5];
                ^FLChild[6];
                ^FLChild[7];
                ^FLChild[8];
                ^FLChild[9];
                ^FLChild[10];
                ^FLChild[11];
                ^FLChild[12];
                ^FLChild[13];
                ^FLChild[14];
                ^FLChild[15];
                ^FLChild[16];
                ^FLChild[17];
                ^FLChild[18];
                ^FLChild[19];

      ENDIF
  ENDIF
ENDIF
[cnt]

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 25 ---

ELSE
   IF ((Sec_SN.SN906_ChildInSocialNetwork > 0 AND (Sec_SN.SN_Child[cnt - sn_start].Name =
Response))
      IF ((piIndex <= GridSize AND ((imForwarded = 0 OR (imForwarded = Empty))))
         ELSE
            IF (piRosterChildIndex > 0)
               CH001a_ChildCheck (CHILD CONFIRM)
                  Do you have [{dynamic constructed text based on how the child was loaded}]?

                  Again, please think of all natural children, fostered, adopted and stepchildren [,
                  including those of] [your husband/ your wife/ your partner].
                  [If a child is listed twice, delete the second one with category \"6. Yes, but
                  already mentioned earlier\", and keep the first]
                  Children overview:;
                  1. Yes
                  [2. Yes, but child's name, gender or year of birth is incorrect]
                  [3. No, child of partner from whom R separated.}
                  [4. No, child died]
                  [5. No, child unknown/ 5. No]
                  [6. Yes, but already mentioned earlier]
                  [97. No, other reason]

            ELSE
               IF (piPreloadChildIndex > 0)
                  CH001a_ChildCheck (CHILD CONFIRM)
                     Do you have [{dynamic constructed text based on how the child was
                     loaded}]?

                     Again, please think of all natural children, fostered, adopted and
                     stepchildren [, including those of] [your husband/ your wife/ your partner].
                     [If a child is listed twice, delete the second one with category \"6. Yes, but
                     already mentioned earlier\", and keep the first]
                     Children overview:;
                     1. Yes
                     [2. Yes, but child's name, gender or year of birth is incorrect]
                     [3. No, child of partner from whom R separated.]
                     [4. No, child died]
                     [5. No, child unknown/ 5. No]
                     [6. Yes, but already mentioned earlier]
                     [97. No, other reason]

               ELSE
                  CH001a_ChildCheck (CHILD CONFIRM)
                     Do you have [{dynamic constructed text based on how the child was
                     loaded}]?

                     Again, please think of all natural children, fostered, adopted and
                     stepchildren [, including those of] [your husband/ your wife/ your partner].
                     [If a child is listed twice, delete the second one with category \"6. Yes, but
                     already mentioned earlier\", and keep the first]
                     Children overview:;
                     1. Yes
                     [2. Yes, but child's name, gender or year of birth is incorrect]
                     [3. No, child of partner from whom R separated.]
                     [4. No, child died]
                     [5. No, child unknown/ 5. No]
                     [6. Yes, but already mentioned earlier]
                     [97. No, other reason]

               ENDIF
            ENDIF
         ENDIF
      CHECK: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex = 0 OR
(piPreloadChildIndex = Empty)))) [Child was mentioned in the social network and might
therefore appear twice. Please check and if same child is listed twice choose option 6 instead of
97;]
         IF (CH001a_ChildCheck = a1)
            IF (CH004_FirstNameOfChild = Empty)
               CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                  ^FL_CH004_5;

                  What is the [correct] first name of [this/ your next] child?
                  Please enter/confirm first name.
                  STRING

            ELSE
               CH004_FirstNameOfChild (FIRST NAME OF CHILD N)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 26 ---

^FL_CH004_5;

What is the *[correct]* first name of *[this/ your next]* child?
Please enter/confirm first name.
STRING

ENDIF
IF (NOT(CH004_FirstNameOfChild = Empty))
   IF (CH005_SexOfChildN = Empty)
      CH005_SexOfChildN (SEX OF CHILD N)
         Is ^CH004_FirstNameOfChild; male or female?
         Ask only if unclear.
         1. Male
         2. Female

   ELSE
      CH005_SexOfChildN (SEX OF CHILD N)
         Is ^CH004_FirstNameOfChild; male or female?
         Ask only if unclear.
         1. Male
         2. Female

   ENDIF
   IF (NOT(CH005_SexOfChildN = Empty))
      IF (CH006_YearOfBirthChildN = Empty)
         CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
            In which year was ^CH004_FirstNameOfChild; born?
            Please enter/confirm year of birth.
            NUMBER [1875..2024]

      ELSE
         CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
            In which year was ^CH004_FirstNameOfChild; born?
            Please enter/confirm year of birth.
            NUMBER [1875..2024]

      ENDIF
   ENDIF
ENDIF
ELSE
   IF (CH001a_ChildCheck = a2)
      CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
         ^FL_CH004_5;

         What is the *[correct]* first name of *[this/ your next]* child?
         Please enter/confirm first name.
         STRING

      CH005_SexOfChildN (SEX OF CHILD N)
         Is ^CH004_FirstNameOfChild; male or female?
         Ask only if unclear.
         1. Male
         2. Female

      CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
         In which year was ^CH004_FirstNameOfChild; born?
         Please enter/confirm year of birth.
         NUMBER [1875..2024]

ELSE
   IF (((piPreloadChildIndex > 0 OR (((piPreloadChildIndex = 0 OR
   (piPreloadChildIndex = Empty) AND (piRosterChildIndex > 0)) AND
   (CH001a_ChildCheck = a6))
      CH505_WhichChildMentionedEarlier (EQUAL TO WHICH CHILD)

         To which child that was already mentioned earlier is ^FL_CHILD_NAME;
         equal?
         ^FLChild[1];
         ^FLChild[2];
         ^FLChild[3];
         ^FLChild[4];
         ^FLChild[5];
         ^FLChild[6];
         ^FLChild[7];
         ^FLChild[8];
         ^FLChild[9];
         ^FLChild[10];
         ^FLChild[11];
         ^FLChild[12];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 27 ---

^FLChild[13];
                        ^FLChild[14];
                        ^FLChild[15];
                        ^FLChild[16];
                        ^FLChild[17];
                        ^FLChild[18];
                        ^FLChild[19];

                  ENDIF
            ENDIF
      ENDIF
[cnt]
ELSE
   IF (NOT(Preload.PreloadedChildren[cnt - 1].Kidcom = Empty))

         IF ((piIndex <= GridSize AND ((imForwarded = 0 OR (imForwarded = Empty)))
         ELSE
               IF (piRosterChildIndex > 0)

                     CH001a_ChildCheck (CHILD CONFIRM)
                        Do you have [{dynamic constructed text based on how the child was
                        loaded}]?

                        Again, please think of all natural children, fostered, adopted and
                        stepchildren [, including those of] [your husband/ your wife/ your partner].
                        [If a child is listed twice, delete the second one with category \"6. Yes, but
                        already mentioned earlier\", and keep the first]
                        Children overview:;
                        1. Yes
                        [2. Yes, but child's name, gender or year of birth is incorrect]
                        [3. No, child of partner from whom R separated.]
                        [4. No, child died]
                        [5. No, child unknown/ 5. No]
                        [6. Yes, but already mentioned earlier]
                        [97. No, other reason]

               ELSE
                     IF (piPreloadChildIndex > 0)

                           CH001a_ChildCheck (CHILD CONFIRM)
                              Do you have [{dynamic constructed text based on how the child
                              was loaded}]?

                              Again, please think of all natural children, fostered, adopted and
                              stepchildren [, including those of] [your husband/ your wife/ your
                              partner].
                              [If a child is listed twice, delete the second one with category \"6.
                              Yes, but already mentioned earlier\", and keep the first]
                              Children overview:;
                              1. Yes
                              [2. Yes, but child's name, gender or year of birth is incorrect]
                              [3. No, child of partner from whom R separated.]
                              [4. No, child died]
                              [5. No, child unknown/ 5. No]
                              [6. Yes, but already mentioned earlier]
                              [97. No, other reason]

                     ELSE
                           CH001a_ChildCheck (CHILD CONFIRM)
                              Do you have [{dynamic constructed text based on how the child
                              was loaded}]?

                              Again, please think of all natural children, fostered, adopted and
                              stepchildren [, including those of] [your husband/ your wife/ your
                              partner].
                              [If a child is listed twice, delete the second one with category \"6.
                              Yes, but already mentioned earlier\", and keep the first]
                              Children overview:;
                              1. Yes
                              [2. Yes, but child's name, gender or year of birth is incorrect]
                              [3. No, child of partner from whom R separated.]
                              [4. No, child died]
                              [5. No, child unknown/ 5. No]
                              [6. Yes, but already mentioned earlier]
                              [97. No, other reason]

                     ENDIF
               ENDIF
         CHECK: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex = 0 OR
         (piPreloadChildIndex = Empty)))) [Child was mentioned in the social network and might
         therefore appear twice. Please check and if same child is listed twice choose option 6
         instead of 97;]
            IF (CH001a_ChildCheck = a1)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 28 ---

IF (CH004_FirstNameOfChild = Empty)
         IF (CH004_FirstNameOfChild = Empty)
              CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                ^FL_CH004_5;

                What is the [correct] first name of [this/ your next] child?
                Please enter/confirm first name.
                STRING

         ELSE
              CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                ^FL_CH004_5;

                What is the [correct] first name of [this/ your next] child?
                Please enter/confirm first name.
                STRING

         ENDIF
         IF (NOT(CH004_FirstNameOfChild = Empty))
              IF (CH005_SexOfChildN = Empty)
                   CH005_SexOfChildN (SEX OF CHILD N)
                     Is ^CH004_FirstNameOfChild; male or female?
                     Ask only if unclear.
                     1. Male
                     2. Female

              ELSE
                   CH005_SexOfChildN (SEX OF CHILD N)
                     Is ^CH004_FirstNameOfChild; male or female?
                     Ask only if unclear.
                     1. Male
                     2. Female

              ENDIF
              IF (NOT(CH005_SexOfChildN = Empty))
                   IF (CH006_YearOfBirthChildN = Empty)
                        CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                          In which year was ^CH004_FirstNameOfChild; born?
                          Please enter/confirm year of birth.
                          NUMBER [1875..2024]

                   ELSE
                        CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                          In which year was ^CH004_FirstNameOfChild; born?
                          Please enter/confirm year of birth.
                          NUMBER [1875..2024]

                   ENDIF
              ENDIF
         ENDIF
ELSE
         IF (CH001a_ChildCheck = a2)
              CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                ^FL_CH004_5;

                What is the [correct] first name of [this/ your next] child?
                Please enter/confirm first name.
                STRING

              CH005_SexOfChildN (SEX OF CHILD N)
                Is ^CH004_FirstNameOfChild; male or female?
                Ask only if unclear.
                1. Male
                2. Female

              CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                In which year was ^CH004_FirstNameOfChild; born?
                Please enter/confirm year of birth.
                NUMBER [1875..2024]

         ELSE
              IF (((piPreloadChildIndex > 0 OR (((piPreloadChildIndex = 0 OR
              (piPreloadChildIndex = Empty) AND (piRosterChildIndex > 0)) AND
              (CH001a_ChildCheck = a6))
                   CH505_WhichChildMentionedEarlier (EQUAL TO WHICH CHILD)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 29 ---

To which child that was already mentioned earlier is
^FL_CHILD_NAME; equal?
^FLChild[1];
^FLChild[2];
^FLChild[3];
^FLChild[4];
^FLChild[5];
^FLChild[6];
^FLChild[7];
^FLChild[8];
^FLChild[9];
^FLChild[10];
^FLChild[11];
^FLChild[12];
^FLChild[13];
^FLChild[14];
^FLChild[15];
^FLChild[16];
^FLChild[17];
^FLChild[18];
^FLChild[19];
                     ENDIF
                  ENDIF
            ENDIF
         [cnt]
      ELSE
      ⊟
            IF ((Sec_SN.SN906_ChildInSocialNetwork > 0 AND (Sec_SN.SN_Child[cnt - sn_start -
      1].Name = Response))
            ⊟
                  IF ((piIndex <= GridSize AND ((imForwarded = 0 OR (imForwarded = Empty)))
                  ⊟
                  ELSE
                  ⊟
                        IF (piRosterChildIndex > 0)
                        ⊟
                           CH001a_ChildCheck (CHILD CONFIRM)
                              Do you have [{dynamic constructed text based on how the child
                              was loaded}]?

                              Again, please think of all natural children, fostered, adopted and
                              stepchildren [, including those of] [your husband/ your wife/ your
                              partner].
                              [If a child is listed twice, delete the second one with category \"6.
                              Yes, but already mentioned earlier\", and keep the first]
                              Children overview:;
                              1. Yes
                              {2. Yes, but child's name, gender or year of birth is incorrect]
                              {3. No, child of partner from whom R separated.}
                              {4. No, child died]
                              {5. No, child unknown/ 5. No]
                              {6. Yes, but already mentioned earlier]
                              {97. No, other reason]

                  ELSE
                  ⊟
                        IF (piPreloadChildIndex > 0)
                        ⊟
                           CH001a_ChildCheck (CHILD CONFIRM)
                              Do you have [{dynamic constructed text based on how the
                              child was loaded}]?

                              Again, please think of all natural children, fostered, adopted
                              and stepchildren [, including those of] [your husband/ your
                              wife/ your partner].
                              [If a child is listed twice, delete the second one with category
                              \"6. Yes, but already mentioned earlier\", and keep the first]
                              Children overview:;
                              1. Yes
                              {2. Yes, but child's name, gender or year of birth is incorrect]
                              {3. No, child of partner from whom R separated.]
                              {4. No, child died]
                              {5. No, child unknown/ 5. No]
                              {6. Yes, but already mentioned earlier]
                              {97. No, other reason}

                        ELSE
                        ⊟
                           CH001a_ChildCheck (CHILD CONFIRM)
                              Do you have [{dynamic constructed text based on how the
                              child was loaded}]?

                              Again, please think of all natural children, fostered, adopted
                              and stepchildren [, including those of] [your husband/ your
                              wife/ your partner].
                              [If a child is listed twice, delete the second one with category
                              \"6. Yes, but already mentioned earlier\", and keep the first]
                              Children overview:;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 30 ---

1. Yes
                        *[2. Yes, but child's name, gender or year of birth is incorrect]*
                        *[3. No, child of partner from whom R separated.]*
                        *[4. No, child died]*
                        *[5. No, child unknown/ 5. No]*
                        *[6. Yes, but already mentioned earlier]*
                        *[97. No, other reason]*

                        *ENDIF*
                *ENDIF*
        *ENDIF*
        **CHECK**: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex = 0 OR
        (piPreloadChildIndex = Empty)))) *[Child was mentioned in the social network and
        might therefore appear twice. Please check and if same child is listed twice choose
        option 6 instead of 97;]*
                *IF (CH001a_ChildCheck = a1)*
                -
                        *IF (CH004_FirstNameOfChild = Empty)*
                        -
                                **CH004_FirstNameOfChild** (FIRST NAME OF CHILD N)
                                ^FL_CH004_5;

                                What is the *[correct]* first name of *[this/ your next]* child?
                                Please enter/confirm first name.
                                STRING

                        *ELSE*
                        -
                                **CH004_FirstNameOfChild** (FIRST NAME OF CHILD N)
                                ^FL_CH004_5;

                                What is the *[correct]* first name of *[this/ your next]* child?
                                Please enter/confirm first name.
                                STRING

                        *ENDIF*
                        *IF (NOT(CH004_FirstNameOfChild = Empty))*
                        -
                                *IF (CH005_SexOfChildN = Empty)*
                                -
                                        **CH005_SexOfChildN** (SEX OF CHILD N)
                                        Is ^CH004_FirstNameOfChild; male or female?
                                        Ask only if unclear.
                                        1. Male
                                        2. Female

                                *ELSE*
                                -
                                        **CH005_SexOfChildN** (SEX OF CHILD N)
                                        Is ^CH004_FirstNameOfChild; male or female?
                                        Ask only if unclear.
                                        1. Male
                                        2. Female

                                *ENDIF*
                                *IF (NOT(CH005_SexOfChildN = Empty))*
                                -
                                        *IF (CH006_YearOfBirthChildN = Empty)*
                                        -
                                                **CH006_YearOfBirthChildN** (YEAR OF BIRTH CHILD N)
                                                In which year was ^CH004_FirstNameOfChild; born?
                                                Please enter/confirm year of birth.
                                                NUMBER [1875..2024]

                                        *ELSE*
                                        -
                                                **CH006_YearOfBirthChildN** (YEAR OF BIRTH CHILD N)
                                                In which year was ^CH004_FirstNameOfChild; born?
                                                Please enter/confirm year of birth.
                                                NUMBER [1875..2024]

                                        *ENDIF*
                                *ENDIF*
                        *ENDIF*
        *ELSE*
        -
                *IF (CH001a_ChildCheck = a2)*
                -
                        **CH004_FirstNameOfChild** (FIRST NAME OF CHILD N)
                        ^FL_CH004_5;

                        What is the *[correct]* first name of *[this/ your next]* child?
                        Please enter/confirm first name.
                        STRING

                        **CH005_SexOfChildN** (SEX OF CHILD N)
                        Is ^CH004_FirstNameOfChild; male or female?
                        Ask only if unclear.

--- page 31 ---

1. Male
2. Female

CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
  In which year was ^CH004_FirstNameOfChild; born?
  Please enter/confirm year of birth.
  NUMBER [1875..2024]

ELSE
  ⊟
      IF (((piPreloadChildIndex > 0 OR (((piPreloadChildIndex = 0 OR
      (piPreloadChildIndex = Empty) AND (piRosterChildIndex > 0)) AND
      (CH001a_ChildCheck = a6))
          ⊟
              CH505_WhichChildMentionedEarlier (EQUAL TO WHICH CHILD)

                  To which child that was already mentioned earlier is
                  ^FL_CHILD_NAME; equal?
                  ^FLChild[1];
                  ^FLChild[2];
                  ^FLChild[3];
                  ^FLChild[4];
                  ^FLChild[5];
                  ^FLChild[6];
                  ^FLChild[7];
                  ^FLChild[8];
                  ^FLChild[9];
                  ^FLChild[10];
                  ^FLChild[11];
                  ^FLChild[12];
                  ^FLChild[13];
                  ^FLChild[14];
                  ^FLChild[15];
                  ^FLChild[16];
                  ^FLChild[17];
                  ^FLChild[18];
                  ^FLChild[19];

          ENDIF
      ENDIF
  ENDIF
  [cnt]
ELSE
  ⊟
      IF ((Child[cnt - 1].CH001a_ChildCheck = a5 AND (Child[cnt -
      1].CH004_FirstNameOfChild = Empty))
          ⊟
              |%CHECK[check_1_[cnt]]%
          ELSE
          ⊟
              IF ((Child[cnt - 1].CH001a_ChildCheck = RESPONSE AND (Child[cnt -
              1].CH001a_ChildCheck <> a5))
                  ⊟
                      IF ((piIndex <= GridSize AND ((imForwarded = 0 OR (imForwarded
                      = Empty))))
                          ⊟
                          ELSE
                          ⊟
                              IF (piRosterChildIndex > 0)
                              ⊟
                                  CH001a_ChildCheck (CHILD CONFIRM)
                                      Do you have [{dynamic constructed text based on how
                                      the child was loaded}]?

                                      Again, please think of all natural children, fostered,
                                      adopted and stepchildren [, including those of] [your
                                      husband/ your wife/ your partner].
                                      [If a child is listed twice, delete the second one with
                                      category \"6. Yes, but already mentioned earlier\", and
                                      keep the first]
                                      Children overview:;
                                      1. Yes
                                      [2. Yes, but child's name, gender or year of birth is
                                      incorrect]
                                      [3. No, child of partner from whom R separated.]
                                      [4. No, child died]
                                      [5. No, child unknown/ 5. No]
                                      [6. Yes, but already mentioned earlier]
                                      [97. No, other reason]

                              ELSE
                              ⊟
                                  IF (piPreloadChildIndex > 0)
                                  ⊟
                                      CH001a_ChildCheck (CHILD CONFIRM)
                                          Do you have [{dynamic constructed text based
                                          on how the child was loaded}]?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 32 ---

Again, please think of all natural children,
fostered, adopted and stepchildren [, including
those of] [your husband/ your wife/ your
partner].
[If a child is listed twice, delete the second one
with category \"6. Yes, but already mentioned
earlier\", and keep the first]
Children overview:;
1. Yes
[2. Yes, but child's name, gender or year of
birth is incorrect]
[3. No, child of partner from whom R
separated.]
[4. No, child died]
[5. No, child unknown/ 5. No]
[6. Yes, but already mentioned earlier]
[97. No, other reason]

ELSE
   ⊟
      CH001a_ChildCheck (CHILD CONFIRM)
         Do you have [{dynamic constructed text based
         on how the child was loaded}]?

         Again, please think of all natural children,
         fostered, adopted and stepchildren [, including
         those of] [your husband/ your wife/ your
         partner].
         [If a child is listed twice, delete the second one
         with category \"6. Yes, but already mentioned
         earlier\", and keep the first]
         Children overview:;
         1. Yes
         [2. Yes, but child's name, gender or year of
         birth is incorrect]
         [3. No, child of partner from whom R
         separated.]
         [4. No, child died]
         [5. No, child unknown/ 5. No]
         [6. Yes, but already mentioned earlier]
         [97. No, other reason]

      ENDIF
   ENDIF
ENDIF
CHECK: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex
= 0 OR (piPreloadChildIndex = Empty))))) [Child was mentioned in the
social network and might therefore appear twice. Please check and if
same child is listed twice choose option 6 instead of 97;]
   IF (CH001a_ChildCheck = a1)
   ⊟
      IF (CH004_FirstNameOfChild = Empty)
      ⊟
         CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
            ^FL_CH004_5;

            What is the [correct] first name of [this/ your next]
            child?
            Please enter/confirm first name.
            STRING

      ELSE
      ⊟
         CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
            ^FL_CH004_5;

            What is the [correct] first name of [this/ your next]
            child?
            Please enter/confirm first name.
            STRING

      ENDIF
      IF (NOT(CH004_FirstNameOfChild = Empty))
      ⊟
         IF (CH005_SexOfChildN = Empty)
         ⊟
            CH005_SexOfChildN (SEX OF CHILD N)
               Is ^CH004_FirstNameOfChild; male or female?
               Ask only if unclear.
               1. Male
               2. Female

         ELSE
         ⊟
            CH005_SexOfChildN (SEX OF CHILD N)
               Is ^CH004_FirstNameOfChild; male or female?
               Ask only if unclear.
               1. Male
               2. Female

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 33 ---

ENDIF
                     IF (NOT(CH005_SexOfChildN = Empty))
                     ⊟
                          IF (CH006_YearOfBirthChildN = Empty)
                          ⊟
                               CH006_YearOfBirthChildN (YEAR OF BIRTH
                               CHILD N)
                                 In which year was
                                 ^CH004_FirstNameOfChild; born?
                                 Please enter/confirm year of birth.
                                 NUMBER [1875..2024]

                               ELSE
                               ⊟
                                    CH006_YearOfBirthChildN (YEAR OF BIRTH
                                    CHILD N)
                                      In which year was
                                      ^CH004_FirstNameOfChild; born?
                                      Please enter/confirm year of birth.
                                      NUMBER [1875..2024]

                               ENDIF
                          ENDIF
                     ENDIF
          ELSE
          ⊟
               IF (CH001a_ChildCheck = a2)
               ⊟
                    CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
                      ^FL_CH004_5;

                      What is the [correct] first name of [this/ your next]
                      child?
                      Please enter/confirm first name.
                      STRING

                    CH005_SexOfChildN (SEX OF CHILD N)
                      Is ^CH004_FirstNameOfChild; male or female?
                      Ask only if unclear.
                      1. Male
                      2. Female

                    CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD N)
                      In which year was ^CH004_FirstNameOfChild; born?
                      Please enter/confirm year of birth.
                      NUMBER [1875..2024]

               ELSE
               ⊟
                    IF (((piPreloadChildIndex > 0 OR
                    (((piPreloadChildIndex = 0 OR (piPreloadChildIndex =
                    Empty) AND (piRosterChildIndex > 0)) AND
                    (CH001a_ChildCheck = a6))
                    ⊟
                         CH505_WhichChildMentionedEarlier (EQUAL TO
                         WHICH CHILD)

                           To which child that was already mentioned
                           earlier is ^FL_CHILD_NAME; equal?
                           ^FLChild[1];
                           ^FLChild[2];
                           ^FLChild[3];
                           ^FLChild[4];
                           ^FLChild[5];
                           ^FLChild[6];
                           ^FLChild[7];
                           ^FLChild[8];
                           ^FLChild[9];
                           ^FLChild[10];
                           ^FLChild[11];
                           ^FLChild[12];
                           ^FLChild[13];
                           ^FLChild[14];
                           ^FLChild[15];
                           ^FLChild[16];
                           ^FLChild[17];
                           ^FLChild[18];
                           ^FLChild[19];

                    ENDIF
               ENDIF
          [cnt]
     ELSE
     ⊟
          IF ((Child[cnt - 1].CH004_FirstNameOfChild <> Empty OR
          (NOT(Preload.PreloadedChildren[cnt - 1].Kidcom = Empty)))
          ⊟
               IF (piIndex <= GridSize AND ((imForwarded = 0 OR

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 34 ---

(imForwarded = Empty)))
   ⊟
   ELSE
   ⊟
        IF (piRosterChildIndex > 0)
        ⊟
             CH001a_ChildCheck (CHILD CONFIRM)
                  Do you have [{dynamic constructed text based
                  on how the child was loaded}]?

                  Again, please think of all natural children,
                  fostered, adopted and stepchildren [, including
                  those of] [your husband/ your wife/ your
                  partner].
                  [If a child is listed twice, delete the second one
                  with category \"6. Yes, but already mentioned
                  earlier\", and keep the first]
                  Children overview:;
                  1. Yes
                  [2. Yes, but child's name, gender or year of
                  birth is incorrect]
                  [3. No, child of partner from whom R
                  separated.]
                  [4. No, child died]
                  [5. No, child unknown/ 5. No]
                  [6. Yes, but already mentioned earlier]
                  [97. No, other reason]

        ELSE
        ⊟
             IF (piPreloadChildIndex > 0)
             ⊟
                  CH001a_ChildCheck (CHILD CONFIRM)
                       Do you have [{dynamic constructed text
                       based on how the child was loaded}]?

                       Again, please think of all natural children,
                       fostered, adopted and stepchildren [,
                       including those of] [your husband/ your
                       wife/ your partner].
                       [If a child is listed twice, delete the
                       second one with category \"6. Yes, but
                       already mentioned earlier\", and keep the
                       first]
                       Children overview:;
                       1. Yes
                       [2. Yes, but child's name, gender or year
                       of birth is incorrect]
                       [3. No, child of partner from whom R
                       separated.]
                       [4. No, child died]
                       [5. No, child unknown/ 5. No]
                       [6. Yes, but already mentioned earlier]
                       [97. No, other reason]

             ELSE
             ⊟
                  CH001a_ChildCheck (CHILD CONFIRM)
                       Do you have [{dynamic constructed text
                       based on how the child was loaded}]?

                       Again, please think of all natural children,
                       fostered, adopted and stepchildren [,
                       including those of] [your husband/ your
                       wife/ your partner].
                       [If a child is listed twice, delete the
                       second one with category \"6. Yes, but
                       already mentioned earlier\", and keep the
                       first]
                       Children overview:;
                       1. Yes
                       [2. Yes, but child's name, gender or year
                       of birth is incorrect]
                       [3. No, child of partner from whom R
                       separated.]
                       [4. No, child died]
                       [5. No, child unknown/ 5. No]
                       [6. Yes, but already mentioned earlier]
                       [97. No, other reason]

             ENDIF
        ENDIF
   ENDIF
   CHECK: (NOT((CH001a_ChildCheck = a97 AND
   ((piPreloadChildIndex = 0 OR (piPreloadChildIndex = Empty))))
   [Child was mentioned in the social network and might therefore
   appear twice. Please check and if same child is listed twice
   choose option 6 instead of 97;]
        IF (CH001a_ChildCheck = a1)
        ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 35 ---

IF (CH004_FirstNameOfChild = Empty)
   ⊟
      CH004_FirstNameOfChild (FIRST NAME OF CHILD
      N)
         ^FL_CH004_5;

         What is the [correct] first name of [this/ your
         next] child?
         Please enter/confirm first name.
         STRING

   ELSE
   ⊟
      CH004_FirstNameOfChild (FIRST NAME OF CHILD
      N)
         ^FL_CH004_5;

         What is the [correct] first name of [this/ your
         next] child?
         Please enter/confirm first name.
         STRING

   ENDIF
   IF (NOT(CH004_FirstNameOfChild = Empty))
   ⊟
         IF (CH005_SexOfChildN = Empty)
         ⊟
               CH005_SexOfChildN (SEX OF CHILD N)
               Is ^CH004_FirstNameOfChild; male or
               female?
               Ask only if unclear.
               1. Male
               2. Female

         ELSE
         ⊟
               CH005_SexOfChildN (SEX OF CHILD N)
               Is ^CH004_FirstNameOfChild; male or
               female?
               Ask only if unclear.
               1. Male
               2. Female

         ENDIF
         IF (NOT(CH005_SexOfChildN = Empty))
         ⊟
               IF (CH006_YearOfBirthChildN = Empty)
               ⊟
                     CH006_YearOfBirthChildN (YEAR
                     OF BIRTH CHILD N)
                        In which year was
                        ^CH004_FirstNameOfChild; born?
                        Please enter/confirm year of birth.
                        NUMBER [1875..2024]

               ELSE
               ⊟
                     CH006_YearOfBirthChildN (YEAR
                     OF BIRTH CHILD N)
                        In which year was
                        ^CH004_FirstNameOfChild; born?
                        Please enter/confirm year of birth.
                        NUMBER [1875..2024]

               ENDIF
         ENDIF
   ENDIF
ELSE
⊟
   IF (CH001a_ChildCheck = a2)
   ⊟
      CH004_FirstNameOfChild (FIRST NAME OF CHILD
      N)
         ^FL_CH004_5;

         What is the [correct] first name of [this/ your
         next] child?
         Please enter/confirm first name.
         STRING

      CH005_SexOfChildN (SEX OF CHILD N)
         Is ^CH004_FirstNameOfChild; male or female?
         Ask only if unclear.
         1. Male
         2. Female

      CH006_YearOfBirthChildN (YEAR OF BIRTH CHILD
      N)
         In which year was ^CH004_FirstNameOfChild;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 36 ---

born?
                                    Please enter/confirm year of birth.
                                    NUMBER [1875..2024]

                        ELSE
                        ⊟
                                IF (((piPreloadChildIndex > 0 OR
                               (((piPreloadChildIndex = 0 OR
                               (piPreloadChildIndex = Empty) AND
                               (piRosterChildIndex > 0)) AND
                               (CH001a_ChildCheck = a6))
                                    ⊟

                                        CH505_WhichChildMentionedEarlier
                                        (EQUAL TO WHICH CHILD)

                                            To which child that was already
                                            mentioned earlier is ^FL_CHILD_NAME;
                                            equal?
                                            ^FLChild[1];
                                            ^FLChild[2];
                                            ^FLChild[3];
                                            ^FLChild[4];
                                            ^FLChild[5];
                                            ^FLChild[6];
                                            ^FLChild[7];
                                            ^FLChild[8];
                                            ^FLChild[9];
                                            ^FLChild[10];
                                            ^FLChild[11];
                                            ^FLChild[12];
                                            ^FLChild[13];
                                            ^FLChild[14];
                                            ^FLChild[15];
                                            ^FLChild[16];
                                            ^FLChild[17];
                                            ^FLChild[18];
                                            ^FLChild[19];

                                    ENDIF
                                ENDIF
                        ENDIF
                    [[cnt]
                    ELSE
                    ⊟
                            IF ((cnt = 1 AND (GridSize > 0))
                            ⊟
                                    IF ((piIndex <= GridSize AND ((imForwarded = 0 OR
                                   (imForwarded = Empty)))
                                    ⊟
                                    ELSE
                                    ⊟
                                            IF (piRosterChildIndex > 0)
                                            ⊟
                                                CH001a_ChildCheck (CHILD CONFIRM)
                                                    Do you have [{dynamic constructed text
                                                    based on how the child was loaded}]?

                                                    Again, please think of all natural children,
                                                    fostered, adopted and stepchildren [,
                                                    including those of] [your husband/ your
                                                    wife/ your partner].
                                                    [If a child is listed twice, delete the
                                                    second one with category \"6. Yes, but
                                                    already mentioned earlier\", and keep the
                                                    first]
                                                    Children overview:;
                                                    1. Yes
                                                    [2. Yes, but child's name, gender or year
                                                    of birth is incorrect]
                                                    [3. No, child of partner from whom R
                                                    separated.]
                                                    [4. No, child died]
                                                    [5. No, child unknown/ 5. No]
                                                    [6. Yes, but already mentioned earlier]
                                                    [97. No, other reason]

                                            ELSE
                                            ⊟
                                                    IF (piPreloadChildIndex > 0)
                                                    ⊟
                                                        CH001a_ChildCheck (CHILD
                                                        CONFIRM)
                                                            Do you have [{dynamic
                                                            constructed text based on how
                                                            the child was loaded}]?

                                                            Again, please think of all natural
                                                            children, fostered, adopted and
                                                            stepchildren [, including those of]

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 37 ---

[your husband/ your wife/ your partner].
[If a child is listed twice, delete the second one with category \"6. Yes, but already mentioned earlier\", and keep the first]
Children overview:;
1. Yes
[2. Yes, but child's name, gender or year of birth is incorrect]
[3. No, child of partner from whom R separated.]
[4. No, child died]
[5. No, child unknown/ 5. No]
[6. Yes, but already mentioned earlier]
[97. No, other reason]

ELSE

   CH001a_ChildCheck (CHILD CONFIRM)
      Do you have [{dynamic constructed text based on how the child was loaded}]?

      Again, please think of all natural children, fostered, adopted and stepchildren {, including those of} {your husband/ your wife/ your partner}.
      [If a child is listed twice, delete the second one with category \"6. Yes, but already mentioned earlier\", and keep the first]
      Children overview:;
      1. Yes
      [2. Yes, but child's name, gender or year of birth is incorrect]
      [3. No, child of partner from whom R separated.]
      [4. No, child died]
      [5. No, child unknown/ 5. No]
      [6. Yes, but already mentioned earlier]
      [97. No, other reason]

   ENDIF
ENDIF
ENDIF
CHECK: (NOT((CH001a_ChildCheck = a97 AND ((piPreloadChildIndex = 0 OR (piPreloadChildIndex = Empty)))) [Child was mentioned in the social network and might therefore appear twice. Please check and if same child is listed twice choose option 6 instead of 97;]
   IF (CH001a_ChildCheck = a1)

      IF (CH004_FirstNameOfChild = Empty)

         CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
            ^FL_CH004_5;

            What is the [correct] first name of [this/ your next] child?
            Please enter/confirm first name.
            STRING

      ELSE

         CH004_FirstNameOfChild (FIRST NAME OF CHILD N)
            ^FL_CH004_5;

            What is the [correct] first name of [this/ your next] child?
            Please enter/confirm first name.
            STRING

      ENDIF
      IF (NOT(CH004_FirstNameOfChild = Empty))

         IF (CH005_SexOfChildN = Empty)

            CH005_SexOfChildN (SEX OF CHILD N)
               Is ^CH004_FirstNameOfChild; male or female?
               Ask only if unclear.
               1. Male

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 38 ---

| 2. Female

*ELSE*
⊟
   **CH005_SexOfChildN** (SEX OF CHILD
   N)
      Is ^CH004_FirstNameOfChild;
      male or female?
      Ask only if unclear.
      1. Male
      2. Female

   *ENDIF*
   *IF (NOT(CH005_SexOfChildN = Empty))*
   ⊟
         *IF (CH006_YearOfBirthChildN =*
         *Empty)*
         ⊟
               **CH006_YearOfBirthChildN**
               (YEAR OF BIRTH CHILD N)
                  In which year was
                  ^CH004_FirstNameOfChild;
                  born?
                  Please enter/confirm year of
                  birth.
                  NUMBER [1875..2024]

            *ELSE*
            ⊟
               **CH006_YearOfBirthChildN**
               (YEAR OF BIRTH CHILD N)
                  In which year was
                  ^CH004_FirstNameOfChild;
                  born?
                  Please enter/confirm year of
                  birth.
                  NUMBER [1875..2024]

            *ENDIF*
      *ENDIF*
   *ENDIF*
*ELSE*
⊟
   *IF (CH001a_ChildCheck = a2)*
   ⊟
      **CH004_FirstNameOfChild** (FIRST NAME OF
      CHILD N)
         ^FL_CH004_5;

         What is the *[correct]* first name of *[this/*
         *your next]* child?
         Please enter/confirm first name.
         STRING

      **CH005_SexOfChildN** (SEX OF CHILD N)
         Is ^CH004_FirstNameOfChild; male or
         female?
         Ask only if unclear.
         1. Male
         2. Female

      **CH006_YearOfBirthChildN** (YEAR OF BIRTH
      CHILD N)
         In which year was
         ^CH004_FirstNameOfChild; born?
         Please enter/confirm year of birth.
         NUMBER [1875..2024]

   *ELSE*
   ⊟
      *IF (((piPreloadChildIndex > 0 OR*
      *(((piPreloadChildIndex = 0 OR*
      *(piPreloadChildIndex = Empty) AND*
      *(piRosterChildIndex > 0)) AND*
      *(CH001a_ChildCheck = a6))*
      ⊟
         **CH505_WhichChildMentionedEarlier**
         (EQUAL TO WHICH CHILD)

            To which child that was already
            mentioned earlier is
            ^FL_CHILD_NAME; equal?
            ^FLChild[1];
            ^FLChild[2];
            ^FLChild[3];
            ^FLChild[4];
            ^FLChild[5];
            ^FLChild[6];
            ^FLChild[7];
            ^FLChild[8];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 39 ---

^FLChild[9];
                                                            ^FLChild[10];
                                                            ^FLChild[11];
                                                            ^FLChild[12];
                                                            ^FLChild[13];
                                                            ^FLChild[14];
                                                            ^FLChild[15];
                                                            ^FLChild[16];
                                                            ^FLChild[17];
                                                            ^FLChild[18];
                                                            ^FLChild[19];

                                                      ENDIF
                                                ENDIF
                                          ENDIF
                                    [cnt]
                                          ENDIF
                                    ENDIF
                              ENDIF
                        ENDIF
                  ENDIF
            ENDIF
      ENDIF
ENDLOOP
CH203_Done (CHILD GRID DONE)

Please make sure that the list of children is complete. If the list is incomplete or not correct, go back by using the
[Page up] key.
Children overview:_overview;
1. Continue

   IF (NumberOFReportedChildren > 0)
   ⊟
         CH302_NatChild ( ALL CHILDREN NATURAL CHILD)
         {Is this child a common natural child/ Is this child a natural child/ Are all these children common natural
         children/ Are all these children natural children} of your own {and your current husband together/ and your
         current wife together/ and your current partner together}?
         1. Yes
         5. No

         IF (CH302_NatChild = a5)
         ⊟
               IF (NumberOFReportedChildren = 1)
               ⊟
               ELSE
               ⊟
                     CH303_WhatChildren (NOT NATURAL CHILDREN)
                           Which of the children are not {common natural/ natural} children of your own {and your
                           current husband together/ and your current wife together/ and your current partner together}?
                           Code all that apply.;
                           SET OF ^FLChild[1];
                           ^FLChild[2];
                           ^FLChild[3];
                           ^FLChild[4];
                           ^FLChild[5];
                           ^FLChild[6];
                           ^FLChild[7];
                           ^FLChild[8];
                           ^FLChild[9];
                           ^FLChild[10];
                           ^FLChild[11];
                           ^FLChild[12];
                           ^FLChild[13];
                           ^FLChild[14];
                           ^FLChild[15];
                           ^FLChild[16];
                           ^FLChild[17];
                           ^FLChild[18];
                           ^FLChild[19];
                           ^FLChild[20];
                           21. deceased child(ren);

               ENDIF
         ENDIF
         LOOP i := 1 TO 20
         ⊟
               IF ((i IN (CH303_WhatChildren))
               ⊟
                     IF (MN002_Person[1].MaritalStatus = a3)
                     ⊟
                     ELSE
                     ⊟
                           CH102_RNatChild (CHILD NATURAL RESPONDENT)
                                 Is ^FLChildname; a natural child of yours?
                                 1. Yes
                                 5. No

                     ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 40 ---

IF ((MN002_Person[1].MaritalStatus = a1 OR (MN002_Person[1].MaritalStatus = a2))
   ⊟
      CH103_PNatChild (CHILD NATURAL PARTNER)
         Is ^FLChildname; a natural child of {your} current {husband/ wife/ partner} [{Name of
         partner/spouse}]?
         1. Yes
         5. No

      ENDIF
      IF (NOT((CH102_RNatChild = a1 OR (CH103_PNatChild = a1)))
      ⊟
         CH104_RExChild (CHILD FROM PREVIOUS RELATIONSHIP RESPONDENT)
            Is ^FLChildname; a child of a former relationship of you?
            1. Yes
            5. No

            IF (((MN002_Person[1].MaritalStatus = a1 OR (MN002_Person[1].MaritalStatus = a2)
         AND (CH104_RExChild = a5))
            ⊟
               CH105_PExChild (CHILD FROM PREVIOUS RELATIONSHIP PARTNER)
                  Is ^FLChildname; a child of a former relationship of {your} current {husband/
                  wife/ partner} [{Name of partner/spouse}]?
                  1. Yes
                  5. No

            ENDIF
      ENDIF
      IF (CH102_RNatChild = a5)
      ⊟
         CH106_RAdoptChild (HAS BEEN ADOPTED BY RESPONDENT)
            Have you adopted ^FLChildname;?
            1. Yes
            5. No

      ENDIF
      IF (CH103_PNatChild = a5)
      ⊟
         CH107_PAdoptChild (HAS BEEN ADOPTED BY PARTNER)
            Has {your} current {husband/ wife/ partner} [{Name of partner/spouse}] adopted
            ^FLChildname;?
            1. Yes
            5. No

      ENDIF
      IF (NOT(((((CH102_RNatChild = a1 OR (CH103_PNatChild = a1) OR (CH104_RExChild = a1)
   OR (CH105_PExChild = a1) OR (CH106_RAdoptChild = a1) OR (CH107_PAdoptChild = a1)))
      ⊟
         CH108_FosterChild (IS FOSTERCHILD)
            Is ^FLChildname; a foster child?
            1. Yes
            5. No

      ENDIF
   [i]
   ENDIF
   ENDLOOP
ENDIF
LOOP cnt := 1 TO 20
⊟
   IF ((.CH201_ChildByEnum.Child[cnt].CH001a_ChildCheck = a1 OR
   (Sec_CH.CH201_ChildByEnum.Child[cnt].CH001a_ChildCheck = a2))
   ⊟
      IF (piRosterChildIndex > 0)
      ⊟
      ELSE
      ⊟
         IF (Sec_CH.CH201_ChildByEnum.Child[piIndex].CONTACT = RESPONSE)
         ⊟
         ELSE
         ⊟
            CH014_ContactChild (CONTACT WITH CHILD)
               During the past twelve months, how often did you have contact with
               ^CH004_FirstNameOfChild;, either in person, by phone, mail, email or any other
               electronic means?
               1. Daily
               2. Several times a week
               3. About once a week
               4. About every two weeks
               5. About once a month
               6. Less than once a month
               7. Never

         ENDIF
      ENDIF
      IF ((piPreloadChildIndex = 0 OR (piPreloadChildIndex = Empty))
      ⊟
         IF (piRosterChildIndex > 0)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 41 ---

ELSE
   IF (Sec_CH.CH201_ChildByEnum.Child[piIndex].DISTANCE <> Empty)
      ELSE
         CH007_ChLWh (WHERE DOES CHILD N LIVE)
            Please look at card 4.
            Where does ^CH004_FirstNameOfChild; live?
              1. In the same household
              2. In the same building
              3. Less than 1 kilometre away
              4. Between 1 and 5 kilometres away
              5. Between 5 and 25 kilometres away
              6. Between 25 and 100 kilometres away
              7. Between 100 and 500 kilometres away
              8. More than 500 kilometres away

         ENDIF
   ENDIF
   IF (piYearOfBirthChild < Year(SysDate()) - 16)
      CH012_MaritalStatusChildN (MARITAL STATUS OF CHILD)
         Please look at card 3.
         What is the marital status of ^CH004_FirstNameOfChild;?
         1. Married and living together with spouse
         2. Registered partnership
         3. Married, living separated from spouse
         4. Never married
         5. Divorced
         6. Widowed

         IF (CH012_MaritalStatusChildN > 2)
            CH013_PartnerChildN (DOES CHILD HAVE PARTNER)
               Does ^CH004_FirstNameOfChild; have a partner who lives with {him/ her}?
                1. Yes
                5. No

            ENDIF
   ENDIF
   IF (CH007_ChLWh = a1)
   ELSE
      CH015_YrChldMoveHh (YEAR CHILD MOVED FROM HOUSEHOLD)
         In which year did ^CH004_FirstNameOfChild; move from the parental household?
         The last move to count. Type "2999" if child still lives at home (e.g. with divorced
         mother). Type "9997" if child never lived in the parental household.
         NUMBER [1900..9997]

         IF (CH015_YrChldMoveHh = RESPONSE)
            CHECK: (((CH015_YrChldMoveHh >= piYearOfBirthChild OR
            (CH015_YrChldMoveHh = 2999) OR (CH015_YrChldMoveHh = 9997)) [Year should
            be greater than or equal to birthyear. If year is correct, please press "suppress" and
            enter a remark to explain;]
            CHECK: ((((CH015_YrChldMoveHh >= 1900 AND (CH015_YrChldMoveHh <= 2024)
            OR (CH015_YrChldMoveHh = 2999) OR (CH015_YrChldMoveHh = 9997)) [Year
            should be greater than 1900 and lower than or equal to 2024;]
            ENDIF
      ENDIF
ELSE
   IF (MN104_Householdmoved = 1)
      CH007_ChLWh (WHERE DOES CHILD N LIVE)
         Please look at card 4.
         Where does ^CH004_FirstNameOfChild; live?
         1. In the same household
         2. In the same building
         3. Less than 1 kilometre away
         4. Between 1 and 5 kilometres away
         5. Between 5 and 25 kilometres away
         6. Between 25 and 100 kilometres away
         7. Between 100 and 500 kilometres away
         8. More than 500 kilometres away

      ENDIF
   ENDIF
IF (piYearOfBirthChild < Year(SysDate()) - 16)
   CH016_ChildOcc (CHILD OCCUPATION)
      Please look at card 6.
      What is ^CH004_FirstNameOfChild;'s employment status?
      1. Full-time employed

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 42 ---

2. Part-time employed
   3. Self-employed or working for own family business
   4. Unemployed
   5. In vocational training/retraining/education
   6. Parental leave
   7. In retirement or early retirement
   8. Permanently sick or disabled
   9. Looking after home or family
   97. Other

   IF ((piPreloadChildIndex = 0 OR (piPreloadChildIndex = Empty))
   ⊟
      CH017_EducChild (CHILD EDUCATION)
         Please look at card 1.
         What is the highest school leaving certificate or school degree
         ^CH004_FirstNameOfChild; has obtained?
         If respondent mentions foreign degree/certificate, please ask if he/she can fit their
         degree into the given categories, if they cannot, please use the "other" option and type
         it in (next screen).
         1. No schooling/education at all
         2. Some education, but less than [instead of put respective country specific degr.]
         3. Country specific category
         4. Country specific category
         5. Country specific category
         6. Country specific category
         7. Country specific category
         8. Country specific category
         9. Country specific category
         10. Country specific category
         11. Country specific category
         12. Country specific category
         13. Country specific category
         14. Country specific category
         15. Country specific category
         16. Country specific category
         17. Country specific category
         18. Country specific category
         19. Country specific category
         20. Country specific category
         95. No degree yet/still in school
         97. Other

         IF (CH017_EducChild = 97)
         ⊟
            CH817_OtherEducChild (CHILD OTHER EDUCATION)
               What other school leaving certificate or school degree has
               ^CH004_FirstNameOfChild; obtained?
               STRING

         ENDIF
      CH018_EdInstChild (FURTHER EDUCATION OR VOCATIONAL TRAINING)
         Please look at card 2.
         Which degrees of higher education or vocational training does
         ^CH004_FirstNameOfChild; have?
         Code all that apply.;
         If respondent answers 'still in education/vocational training' please ask if he/she already
         holds one of the other degrees on the showcard.
         SET OF 1. No higher education/vocational training
         2. Some education, but less than [instead of put respective country specific degr.]
         3. Country specific category
         4. Country specific category
         5. Country specific category
         6. Country specific category
         7. Country specific category
         8. Country specific category
         9. Country specific category
         10. Country specific category
         11. Country specific category
         12. Country specific category
         13. Country specific category
         14. Country specific category
         15. Country specific category
         16. Country specific category
         17. Country specific category
         18. Country specific category
         19. Country specific category
         20. Country specific category
         95. Still in education/vocational training
         97. Other

         IF ((97 IN (CH018_EdInstChild))
         ⊟
            CH818_OtherEdInstChild (OTHER FURTHER EDUCATION OR VOCATIONAL TRAINING)
               What other degree of higher education or vocational training does
               ^CH004_FirstNameOfChild; have?
               STRING

         ENDIF
      CH019_NoChildren (NUMBER OF CHILDREN OF CHILD)
         How many children - if any - does ^CH004_FirstNameOfChild; have?
         Please count all natural children, fostered, adopted and stepchildren, including those of
         a spouse or partner.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 43 ---

NUMBER [0..25]

         IF (CH019_NoChildren > 0)
         ⊟
              CH020_YrBrthYCh (YEAR OF BIRTH YOUNGEST CHILD)
              In which year was the [youngest] child of ^CH004_FirstNameOfChild; born?
              NUMBER [1875..2024]

         ENDIF
         ENDIF
    ENDIF
    [cnt]
    ENDIF
ENDLOOP   IF (MN101_Longitudinal = 1)
⊟
     IF (numberofcheckedpreloadchildren > 0)
     ⊟
          CH507_IntroCheckChildren (INTRODUCTION TEXT CHILDREN CHECK)
          We would like to update some of the information we have on your [child/ children].
          1. Continue

          CH524_LocationCheckChildren (CHECK LOCATION OF CHILDREN CHANGED)
          Has [your child/ any of your children] changed residence since the interview in
          ^FLLastInterviewMonthYear;?
          1. Yes
          5. No

            IF (CH524_LocationCheckChildren = a1)
            ⊟
                 IF (NumberOFReportedChildren > 1)
                 ⊟
                      CH525_LocationWhom (WHICH CHILD)
                      Which child has moved house?
                      Code all that apply.;
                      SET OF ^FLChild[1];
                      ^FLChild[2];
                      ^FLChild[3];
                      ^FLChild[4];
                      ^FLChild[5];
                      ^FLChild[6];
                      ^FLChild[7];
                      ^FLChild[8];
                      ^FLChild[9];
                      ^FLChild[10];
                      ^FLChild[11];
                      ^FLChild[12];
                      ^FLChild[13];
                      ^FLChild[14];
                      ^FLChild[15];
                      ^FLChild[16];
                      ^FLChild[17];
                      ^FLChild[18];
                      ^FLChild[19];
                      ^FLChild[20];
                      21. deceased child(ren);

                 ENDIF
                 IF (NOT(MN104_Householdmoved = 1))
                 ⊟
                      LOOP i := 1 TO 20
                      ⊟
                           IF (NumberOFReportedChildren = 1)
                           ⊟
                                IF ((Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a1 OR
                                (Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a2))
                                ⊟
                                     CH526_LocationChanged (CHILD LOCATION)
                                     Please look at card 4: Where does ^FL_CH526_1; live?
                                     1. In the same household
                                     2. In the same building
                                     3. Less than 1 kilometre away
                                     4. Between 1 and 5 kilometres away
                                     5. Between 5 and 25 kilometres away
                                     6. Between 25 and 100 kilometres away
                                     7. Between 100 and 500 kilometres away
                                     8. More than 500 kilometres away

                                [i]
                                ENDIF
                           ELSE
                           ⊟
                                IF (((i IN (CH525_LocationWhom) AND
                                ((Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> 0 AND
                                (Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> Empty)))
                                ⊟
                                     CH526_LocationChanged (CHILD LOCATION)
                                     Please look at card 4: Where does ^FL_CH526_1; live?
                                     1. In the same household

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 44 ---

2. In the same building
                        3. Less than 1 kilometre away
                        4. Between 1 and 5 kilometres away
                        5. Between 5 and 25 kilometres away
                        6. Between 25 and 100 kilometres away
                        7. Between 100 and 500 kilometres away
                        8. More than 500 kilometres away

                        [i]
                        ENDIF
                    ENDIF
                ENDLOOP
            ENDIF
        ENDIF
        IF (a_preloaded_child_aged_smaller_22 = 1)
        ⊟
            CH508_SchoolCheckChildren (CHECK SCHOOL CHANGED)
                Please look at card 1.
                Since the interview in ^FLLastInterviewMonthYear;, has [your child/ any of your children]
                obtained one of the school leaving certificates listed on this card?
                1. Yes
                5. No

                IF (CH508_SchoolCheckChildren = a1)
                ⊟
                        IF (NumberOFReportedChildren > 1)
                        ⊟
                            CH509_SchoolWhom (WHICH CHILD)
                                Which child?
                                Code all that apply.;
                                SET OF ^FLChild[1];
                                ^FLChild[2];
                                ^FLChild[3];
                                ^FLChild[4];
                                ^FLChild[5];
                                ^FLChild[6];
                                ^FLChild[7];
                                ^FLChild[8];
                                ^FLChild[9];
                                ^FLChild[10];
                                ^FLChild[11];
                                ^FLChild[12];
                                ^FLChild[13];
                                ^FLChild[14];
                                ^FLChild[15];
                                ^FLChild[16];
                                ^FLChild[17];
                                ^FLChild[18];
                                ^FLChild[19];
                                ^FLChild[20];
                                21. deceased child(ren);

                        ENDIF
                        LOOP i := 1 TO 20
                        ⊟
                                IF (NumberOFReportedChildren = 1)
                                ⊟
                                        IF ((Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a1 OR
                                        (Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a2))
                                        ⊟
                                            CH510_Leaving_certificate (LEAVING_CERTIFICATE)
                                                What is the highest school leaving certificate or school degree that
                                                ^FL_CH510_1; has obtained?
                                                If respondent mentions foreign degree/certificate, please ask if
                                                he/she can fit their degree into the given categories, if they cannot,
                                                please use the "other" option and type it in (next screen).
                                                1. No schooling/education at all
                                                2. Some education, but less than [instead of put respective country
                                                specific degr.]
                                                3. Country specific category
                                                4. Country specific category
                                                5. Country specific category
                                                6. Country specific category
                                                7. Country specific category
                                                8. Country specific category
                                                9. Country specific category
                                                10. Country specific category
                                                11. Country specific category
                                                12. Country specific category
                                                13. Country specific category
                                                14. Country specific category
                                                15. Country specific category
                                                16. Country specific category
                                                17. Country specific category
                                                18. Country specific category
                                                19. Country specific category
                                                20. Country specific category
                                                95. No degree yet/still in school
                                                97. Other

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 45 ---

IF (CH510_Leaving_certificate = 97)
         ⊟
              CH810_OtherLeaving_certificate (OTHER LEAVING
              CERTIFICATE)
                   What other school leaving certificate or school degree has
                   ^FL_CH510_1; obtained?
                   STRING

         ENDIF
         [i]
    ENDIF
ELSE
⊟
     IF (((i IN (CH509_SchoolWhom) AND
     ((Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> 0 OR
     (Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> Empty)))
          ⊟
               CH510_Leaving_certificate (LEAVING_CERTIFICATE)
               What is the highest school leaving certificate or school degree that
               ^FL_CH510_1; has obtained?
               If respondent mentions foreign degree/certificate, please ask if
               he/she can fit their degree into the given categories, if they cannot,
               please use the "other" option and type it in (next screen).
               1. No schooling/education at all
               2. Some education, but less than [instead of put respective country
               specific degr.]
               3. Country specific category
               4. Country specific category
               5. Country specific category
               6. Country specific category
               7. Country specific category
               8. Country specific category
               9. Country specific category
               10. Country specific category
               11. Country specific category
               12. Country specific category
               13. Country specific category
               14. Country specific category
               15. Country specific category
               16. Country specific category
               17. Country specific category
               18. Country specific category
               19. Country specific category
               20. Country specific category
               95. No degree yet/still in school
               97. Other

               IF (CH510_Leaving_certificate = 97)
               ⊟
                    CH810_OtherLeaving_certificate (OTHER LEAVING
                    CERTIFICATE)
                         What other school leaving certificate or school degree has
                         ^FL_CH510_1; obtained?
                         STRING

               ENDIF
               [i]
          ENDIF
     ENDIF
ENDLOOP
     ENDIF
ENDIF
IF (a_preloaded_child_aged_smaller_32 = 1)
⊟
     CH511_DegreeCheckChildren (CHECK DEGREE CHANGED)
          Please look at card 2.
          Since the interview in ^FLLastInterviewMonthYear;, has {your child/ any of your children}
          obtained one of the degrees of higher education or vocational training listed on this card?
          1. Yes
          5. No

     IF (CH511_DegreeCheckChildren = a1)
     ⊟
          IF (NumberOFReportedChildren > 1)
          ⊟
               CH512_DegreeWhom (WHICH CHILD)
                    Which child?
                    Code all that apply.;
                    SET OF ^FLChild[1];
                    ^FLChild[2];
                    ^FLChild[3];
                    ^FLChild[4];
                    ^FLChild[5];
                    ^FLChild[6];
                    ^FLChild[7];
                    ^FLChild[8];
                    ^FLChild[9];
                    ^FLChild[10];
                    ^FLChild[11];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 46 ---

^FLChild[12];
            ^FLChild[13];
            ^FLChild[14];
            ^FLChild[15];
            ^FLChild[16];
            ^FLChild[17];
            ^FLChild[18];
            ^FLChild[19];
            ^FLChild[20];
            21. deceased child(ren);

   ENDIF
   LOOP i := 1 TO 20
   ⊟
         IF (NumberOFReportedChildren = 1)
         ⊟
               IF ((Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a1 OR
               (Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a2))
               ⊟
                     CH513_DegreeObtained (DEGREE OBTAINED)
                        Which degrees of higher education or vocational training has
                        ^FL_CH513_1; obtained?
                        Code all that apply.;
                        If respondent answers <> please ask if he/she already holds one of
                        the other degrees on the showcard.
                        SET OF 1. No higher education/vocational training
                        2. Some education, but less than [instead of put respective country
                        specific degr.]
                        3. Country specific category
                        4. Country specific category
                        5. Country specific category
                        6. Country specific category
                        7. Country specific category
                        8. Country specific category
                        9. Country specific category
                        10. Country specific category
                        11. Country specific category
                        12. Country specific category
                        13. Country specific category
                        14. Country specific category
                        15. Country specific category
                        16. Country specific category
                        17. Country specific category
                        18. Country specific category
                        19. Country specific category
                        20. Country specific category
                        95. Still in education/vocational training
                        97. Other

                        IF (97 IN (CH513_DegreeObtained))
                        ⊟
                              CH813_OtherDegreeObtained (OTHER DEGREE OBTAINED)
                                 What other degree of higher education or vocational training
                                 does ^FL_CH513_1; have?
                                 STRING

                        ENDIF
               [i]
         ENDIF
   ELSE
   ⊟
         IF (((i IN (CH512_DegreeWhom) AND
         ((Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> 0 OR
         (Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> Empty)))
         ⊟
               CH513_DegreeObtained (DEGREE OBTAINED)
                  Which degrees of higher education or vocational training has
                  ^_CH513_1; obtained?
                  Code all that apply.;
                  If respondent answers <> please ask if he/she already holds one of
                  the other degrees on the showcard.
                  SET OF 1. No higher education/vocational training
                  2. Some education, but less than [instead of put respective country
                  specific degr.]
                  3. Country specific category
                  4. Country specific category
                  5. Country specific category
                  6. Country specific category
                  7. Country specific category
                  8. Country specific category
                  9. Country specific category
                  10. Country specific category
                  11. Country specific category
                  12. Country specific category
                  13. Country specific category
                  14. Country specific category
                  15. Country specific category
                  16. Country specific category
                  17. Country specific category
                  18. Country specific category

--- page 47 ---

19. Country specific category
                        20. Country specific category
                        95. Still in education/vocational training
                        97. Other

                        IF ((97 IN (CH513_DegreeObtained))
                        ⊟
                            CH813_OtherDegreeObtained (OTHER DEGREE OBTAINED)
                              What other degree of higher education or vocational training
                              does ^FL_CH513_1; have?
                              STRING

                        ENDIF
                    [i]
                ENDIF
            ENDIF
        ENDLOOP
    ENDIF
ENDIF
IF (a_preloaded_child_aged_bigger_16 = 1)
⊟
    CH514_MaritalStatusCheckChildren (CHECK MARITAL STATUS CHANGED)
      Since the interview in ^FLLastInterviewMonthYear;, has {your child/ any of your children}
      changed his or her marital status?
      1. Yes
      5. No

      IF (CH514_MaritalStatusCheckChildren = a1)
      ⊟
            IF (NumberOFReportedChildren > 1)
            ⊟
                CH515_MaritalStatusWhom (WHICH CHILD)
                  Which child has changed his or her marital status?
                  Code all that apply.;
                  SET OF ^FLChild[1];
                  ^FLChild[2];
                  ^FLChild[3];
                  ^FLChild[4];
                  ^FLChild[5];
                  ^FLChild[6];
                  ^FLChild[7];
                  ^FLChild[8];
                  ^FLChild[9];
                  ^FLChild[10];
                  ^FLChild[11];
                  ^FLChild[12];
                  ^FLChild[13];
                  ^FLChild[14];
                  ^FLChild[15];
                  ^FLChild[16];
                  ^FLChild[17];
                  ^FLChild[18];
                  ^FLChild[19];
                  ^FLChild[20];
                  21. deceased child(ren);

            ENDIF
            LOOP i := 1 TO 20
            ⊟
                  IF (NumberOFReportedChildren = 1)
                  ⊟
                        IF ((Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a1 OR
                        (Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a2))
                        ⊟
                            CH516_MaritalStatus (MARITAL STATUS)
                              Please look at card 3. What is {Name of child)} 's marital status?
                              1. Married and living together with spouse
                              2. Registered partnership
                              3. Married, living separated from spouse
                              4. Never married
                              5. Divorced
                              6. Widowed

                        [i]
                        ENDIF
                  ELSE
                  ⊟
                        IF (((i IN (CH515_MaritalStatusWhom) AND
                        ((Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> 0 OR
                        (Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> Empty)))
                        ⊟
                            CH516_MaritalStatus (MARITAL STATUS)
                              Please look at card 3. What is {Name of child)} 's marital status?
                              1. Married and living together with spouse
                              2. Registered partnership
                              3. Married, living separated from spouse
                              4. Never married
                              5. Divorced
                              6. Widowed

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 48 ---

[i]
                        ENDIF
                    ENDIF
                ENDLOOP
        ENDIF
        CH517_BecomeParent (CHECK GRANDCHILDREN CHANGED)
          Since the interview in ^FLLastInterviewMonthYear;, has {your child/ any of your children}
          become parent of a new child?
          Please include natural children, fostered, adopted and stepchildren, including those of a spouse
          or partner.
          1. Yes
          5. No

          IF (CH517_BecomeParent = a1)
          ⊟
                IF (NumberOFReportedChildren > 1)
                ⊟
                      CH518_ParentWhom (WHICH CHILD)
                        Which child has become parent of a new child?
                        Check all children that apply.
                        SET OF ^FLChild[1];
                        ^FLChild[2];
                        ^FLChild[3];
                        ^FLChild[4];
                        ^FLChild[5];
                        ^FLChild[6];
                        ^FLChild[7];
                        ^FLChild[8];
                        ^FLChild[9];
                        ^FLChild[10];
                        ^FLChild[11];
                        ^FLChild[12];
                        ^FLChild[13];
                        ^FLChild[14];
                        ^FLChild[15];
                        ^FLChild[16];
                        ^FLChild[17];
                        ^FLChild[18];
                        ^FLChild[19];
                        ^FLChild[20];
                        21. deceased child(ren);

                ENDIF
                LOOP i := 1 TO 20
                ⊟
                      IF (NumberOFReportedChildren = 1)
                      ⊟
                              IF ((Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a1 OR
                              (Sec_CH.CH201_ChildByEnum.Child[i].CH001a_ChildCheck = a2))
                              ⊟
                                    CH519_NewK (HOW MANY NEW CHILDREN)
                                      How many children does [{Name of child}] have altogether?
                                      NUMBER [0..25]

                                      IF (CH519_NewK > 0)
                                      ⊟
                                            CH520_YoungestBorn (YOUNGEST BORN)
                                              In which year was {this child/ the youngest of these children}
                                              born?
                                              NUMBER [1900..2024]

                                              IF (CH520_YoungestBorn = RESPONSE)
                                              ⊟
                                                    CHECK: (NOT(CH520_YoungestBorn <
                                                    Preload.InterviewYear_Regular)) {Year should be greater
                                                    than or equal to the year of last interview. If year is
                                                    correct, please press "suppress" and enter a remark to
                                                    explain.;}
                                                    ENDIF
                                              ENDIF
                                      [i]
                                    ENDIF
                      ELSE
                      ⊟
                              IF (((i IN (CH518_ParentWhom) AND
                              ((Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> 0 OR
                              (Sec_CH.CH201_ChildByEnum.Child[i].PRELOAD_ID <> Empty)))
                              ⊟
                                    CH519_NewK (HOW MANY NEW CHILDREN)
                                      How many children does [{Name of child}] have altogether?
                                      NUMBER [0..25]

                                      IF (CH519_NewK > 0)
                                      ⊟
                                            CH520_YoungestBorn (YOUNGEST BORN)
                                              In which year was {this child/ the youngest of these children}
                                              born?
                                              NUMBER [1900..2024]

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 49 ---

IF (CH520_YoungestBorn = RESPONSE)
         ⊟
              CHECK: (NOT(CH520_YoungestBorn <
              Preload.InterviewYear_Regular)) [Year should be greater
              than or equal to the year of last interview. If year is
              correct, please press "suppress" and enter a remark to
              explain.;]
         ENDIF
         ENDIF
    [i]
    ENDIF
    ENDIF
ENDLOOP
ENDIF
ENDIF
ENDIF
ENDIF
CH021_NoGrandChild (NUMBER OF GRANDCHILDREN)
  Talking about grandchildren, how many grandchildren do you[and your][husband/ wife/ partner] have altogether?
  Include grandchildren from previous relationships.
  NUMBER

  IF (CH021_NoGrandChild > 0)
  ⊟
       CH022_GreatGrChild (HAS GREAT-GRANDCHILDREN)
         Do you [or your] [husband/ wife/ partner] have any great-grandchildren?
         1. Yes
         5. No

  ENDIF
  CH023_IntCheck (WHO ANSWERED QUESTIONS IN SECTION CH)

    IWER CHECK:
    Who answered the questions in this section?
    1. Respondent only
    2. Respondent and proxy
    3. Proxy only

ENDIF
ENDIF
IF (((PH IN (Test) OR ((ALL IN (Test)))
⊟
  PH001_Intro (INTRO HEALTH)
    Now I have some questions about your health.
    1. Continue

  PH003_HealthGen2 (HEALTH IN GENERAL QUESTION 2)
    Would you say your health is...
    Read out.;
    1. Excellent
    2. Very good
    3. Good
    4. Fair
    5. Poor

  PH004_LStIll (LONG-TERM ILLNESS)
    Some people suffer from chronic or long-term health problems. By chronic or long-term we mean it has troubled you over a
    period of time or is likely to affect you over a period of time. Do you have any such health problems, illness, disability or
    infirmity?
    Including mental health problems
    1. Yes
    5. No

  PH005_LimAct (LIMITED ACTIVITIES)
    For the past six months at least, to what extent have you been limited because of a health problem in activities people usually
    do?
    Read out.;
    1. Severely limited
    2. Limited, but not severely
    3. Not limited

    IF ((MN808_AgeRespondent <= 75 AND (MN024_NursingHome = a1))
    ⊟
         PH061_LimPaidWork (PROBLEM THAT LIMITS PAID WORK)
           Do you have any health problem or disability that limits the kind or amount of paid work you can do?
           1. Yes
           5. No

    ENDIF
  PH006_DocCond (DOCTOR TOLD YOU HAD CONDITIONS)
    Please look at card 7.
    [Has a doctor ever told you that you had/ Do you currently have] any of the conditions on this card? [With this we mean that a
    doctor has told you that you have this condition, and that you are either currently being treated for or bothered by this
    condition.] Please tell me the number or numbers of the conditions.
    Code all that apply.;
    SET OF 1. A heart attack including myocardial infarction or coronary thrombosis or any other heart problem including congestive
    heart failure
    2. High blood pressure or hypertension
    3. High blood cholesterol
    4. A stroke or cerebral vascular disease

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 50 ---

5. Diabetes or high blood sugar
        6. Chronic lung disease such as chronic bronchitis or emphysema
        10. Cancer or malignant tumour, including leukaemia or lymphoma, but excluding minor skin cancers
        11. Stomach or duodenal ulcer, peptic ulcer
        12. Parkinson's disease
        13. Cataracts
        14. Hip fracture
        15. Other fractures
        16. Alzheimer's disease, dementia, organic brain syndrome, senility or any other serious memory impairment
        18. Other affective or emotional disorders, including anxiety, nervous or psychiatric problems
        19. Rheumatoid Arthritis
        20. Osteoarthritis, or other rheumatism
        21. Chronic kidney disease
        96. None
        97. Other conditions, not yet mentioned

CHECK: (NOT((count(PH006_DocCond) > 1 AND ((96 IN (PH006_DocCond)))) *[You cannot select '96' together with any other answer. Please change your answer.;]*
   IF ((a97 IN (PH006_DocCond))
   ⊟

         PH007_OthCond (OTHER CONDITIONS)
            What other conditions have you had?
            Probe
            STRING

   ENDIF
   LOOP cnt := 1 TO 21
   ⊟

         IF ((cnt IN (PH006_DocCond))
         ⊟

               IF (piIndexSub = 10)
               ⊟

                     PH008_OrgCan (CANCER IN WHICH ORGANS)
                        In which organ or part of the body do you have or have you had cancer?
                        Code all that apply.;
                        1. Brain
                        2. Oral cavity
                        3. Larynx
                        4. Other pharynx
                        5. Thyroid
                        6. Lung
                        7. Breast
                        8. Oesophagus
                        9. Stomach
                        10. Liver
                        11. Pancreas
                        12. Kidney
                        13. Prostate
                        14. Testicle
                        15. Ovary
                        16. Cervix
                        17. Endometrium
                        18. Colon or rectum
                        19. Bladder
                        20. Skin
                        21. Lymphoma
                        22. Leukemia
                        97. Other organ

               ENDIF
               IF (MN101_Longitudinal = 0)
               ⊟

                     PH009_AgeCond (AGE WHEN CONDITION STARTED)
                        About how old were you when you were first told by a doctor that you had*[a heart attack or any other heart problem/ high blood pressure/ high blood cholesterol/ a stroke or cerebral vascular disease/ diabetes or high blood sugar/ chronic lung disease/ cancer/ stomach or duodenal ulcer/ Parkinson's disease/ cataracts/ hip fracture/ other fractures/ Alzheimer's disease, dementia or other serious memory impairment/ Affective or emotional disorders/ Rheumatoid Arthritis/ Osteoarthritis, or other rheumatism/ Chronic kidney disease]*?
                        NUMBER [0..125]

                        IF (PH009_AgeCond = RESPONSE)
                        ⊟

                              CHECK: (NOT(PH009_AgeCond > MN808_AgeRespondent)) *[Age should be less than or equal to respondent's age;]*
                        ENDIF
               ENDIF
               [cnt]
         ENDIF
   ENDLOOP     IF ((97 IN (PH006_DocCond))
   ⊟

         IF (piIndexSub = 10)
         ⊟

               PH008_OrgCan (CANCER IN WHICH ORGANS)
                  In which organ or part of the body do you have or have you had cancer?
                  Code all that apply.;
                  1. Brain
                  2. Oral cavity
                  3. Larynx
                  4. Other pharynx

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 51 ---

5. Thyroid
                    6. Lung
                    7. Breast
                    8. Oesophagus
                    9. Stomach
                    10. Liver
                    11. Pancreas
                    12. Kidney
                    13. Prostate
                    14. Testicle
                    15. Ovary
                    16. Cervix
                    17. Endometrium
                    18. Colon or rectum
                    19. Bladder
                    20. Skin
                    21. Lymphoma
                    22. Leukemia
                    97. Other organ

        ENDIF
        IF (MN101_Longitudinal = 0)
        ⊟
            PH009_AgeCond (AGE WHEN CONDITION STARTED)
            About how old were you when you were first told by a doctor that you had[a heart attack or any other heart
            problem/ high blood pressure/ high blood cholesterol/ a stroke or cerebral vascular disease/ diabetes or high blood
            sugar/ chronic lung disease/ cancer/ stomach or duodenal ulcer/ Parkinson's disease/ cataracts/ hip fracture/ other
            fractures/ Alzheimer's disease, dementia or other serious memory impairment/ Affective or emotional disorders/
            Rheumatoid Arthritis/ Osteoarthritis, or other rheumatism/ Chronic kidney disease]?
            NUMBER [0..125]

              IF (PH009_AgeCond = RESPONSE)
              ⊟
                  CHECK: (NOT(PH009_AgeCond > MN808_AgeRespondent)) [Age should be less than or equal to respondent's
                  age;]
                  ENDIF
        ENDIF
        [22]
        ENDIF
        IF (MN101_Longitudinal = 1)
        ⊟
            PH072_HadCondition (HAD CONDITION)
            [For a few conditions, we would like to know exactly what has happened in the past couple of years.
            ]
            Since our interview in ^FLLastInterviewMonthYear; have you[had a heart attack/ had a stroke or been diagnosed with
            cerebral vascular disease/ been diagnosed with cancer/ suffered a hip fracture]?
            1. Yes
            5. No

            IF (PH072_HadCondition = a1)
            ⊟
                  IF (piIndex = 3)
                  ⊟
                      PH080_OrgCan (CANCER IN WHICH ORGANS)
                        In which organ or part of the body do you have or have you had cancer?
                        Code all that apply.;
                        1. Brain
                        2. Oral cavity
                        3. Larynx
                        4. Other pharynx
                        5. Thyroid
                        6. Lung
                        7. Breast
                        8. Oesophagus
                        9. Stomach
                        10. Liver
                        11. Pancreas
                        12. Kidney
                        13. Prostate
                        14. Testicle
                        15. Ovary
                        16. Cervix
                        17. Endometrium
                        18. Colon or rectum
                        19. Bladder
                        20. Skin
                        21. Lymphoma
                        22. Leukemia
                        97. Other organ

                  ENDIF
                  PH076_YearCondition (YEAR MOST RECENT CONDITION)
                  In what year was your most recent [heart attack/ stroke or cerebral vascular disease/ cancer/ hip fracture]?
                  NUMBER [1900..2024]

                    IF (PH076_YearCondition = RESPONSE)
                    ⊟
                        CHECK: (NOT(PH076_YearCondition < Preload.InterviewYear_Regular)) [Year should be greater than or equal
                        to the year of last interview. If year is correct, please press "suppress" and enter a remark to explain.;]
                    ENDIF

--- page 52 ---

PH077_MonthCondition (MONTH MOST RECENT CONDITION)
         In what month was that?
         1. January
         2. February
         3. March
         4. April
         5. May
         6. June
         7. July
         8. August
         9. September
         10. October
         11. November
         12. December

         IF ((PH077_MonthCondition = RESPONSE AND (PH076_YearCondition = Preload.InterviewYear_Regular))
         -
            CHECK: (NOT(PH077_MonthCondition < Preload.InterviewMonth_Regular)) [Month should be greater than or
            equal to the month of last interview. If month is correct, please press "suppress" and enter a remark to
            explain.;]
         ENDIF
      PH071_HadConditionHowMany (HOW MANY)
         How many[heart attacks/ strokes or cerebral vascular diseases/ cancers/ hip fractures] have you had since we
         talked to you in ^FLLastInterviewMonthYear;?
         1. 1
         2. 2
         3. 3 or more

   ENDIF
[1]
PH072_HadCondition (HAD CONDITION)
   [For a few conditions, we would like to know exactly what has happened in the past couple of years.
   ]
   Since our interview in ^FLLastInterviewMonthYear; have you[had a heart attack/ had a stroke or been diagnosed with
   cerebral vascular disease/ been diagnosed with cancer/ suffered a hip fracture]?
   1. Yes
   5. No

   IF (PH072_HadCondition = a1)
   -
         IF (piIndex = 3)
         -
            PH080_OrgCan (CANCER IN WHICH ORGANS)
               In which organ or part of the body do you have or have you had cancer?
               Code all that apply.;
               1. Brain
               2. Oral cavity
               3. Larynx
               4. Other pharynx
               5. Thyroid
               6. Lung
               7. Breast
               8. Oesophagus
               9. Stomach
               10. Liver
               11. Pancreas
               12. Kidney
               13. Prostate
               14. Testicle
               15. Ovary
               16. Cervix
               17. Endometrium
               18. Colon or rectum
               19. Bladder
               20. Skin
               21. Lymphoma
               22. Leukemia
               97. Other organ

         ENDIF
         PH076_YearCondition (YEAR MOST RECENT CONDITION)
            In what year was your most recent [heart attack/ stroke or cerebral vascular disease/ cancer/ hip fracture]?
            NUMBER [1900..2024]

            IF (PH076_YearCondition = RESPONSE)
            -
               CHECK: (NOT(PH076_YearCondition < Preload.InterviewYear_Regular)) [Year should be greater than or equal
               to the year of last interview. If year is correct, please press "suppress" and enter a remark to explain.;]
            ENDIF
         PH077_MonthCondition (MONTH MOST RECENT CONDITION)
            In what month was that?
            1. January
            2. February
            3. March
            4. April
            5. May
            6. June
            7. July
            8. August
            9. September
            10. October

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 53 ---

11. November
                12. December

                *IF ((PH077_MonthCondition = RESPONSE AND (PH076_YearCondition = Preload.InterviewYear_Regular))*
                ⊟
                    **CHECK**: (NOT(PH077_MonthCondition < Preload.InterviewMonth_Regular)) *[Month should be greater than or equal to the month of last interview. If month is correct, please press "suppress" and enter a remark to explain.;]*
                *ENDIF*
        **PH071_HadConditionHowMany** (HOW MANY)
          How many*[heart attacks/ strokes or cerebral vascular diseases/ cancers/ hip fractures]* have you had since we talked to you in ^FLLastInterviewMonthYear;?
          1. 1
          2. 2
          3. 3 or more

    *ENDIF*
[2]
**PH072_HadCondition** (HAD CONDITION)
    *[For a few conditions, we would like to know exactly what has happened in the past couple of years.*
    *]*
Since our interview in ^FLLastInterviewMonthYear; have you*[had a heart attack/ had a stroke or been diagnosed with cerebral vascular disease/ been diagnosed with cancer/ suffered a hip fracture]*?
1. Yes
5. No

    *IF (PH072_HadCondition = a1)*
    ⊟
            *IF (piIndex = 3)*
            ⊟
                **PH080_OrgCan** (CANCER IN WHICH ORGANS)
                  In which organ or part of the body do you have or have you had cancer?
                  Code all that apply.;
                  1. Brain
                  2. Oral cavity
                  3. Larynx
                  4. Other pharynx
                  5. Thyroid
                  6. Lung
                  7. Breast
                  8. Oesophagus
                  9. Stomach
                  10. Liver
                  11. Pancreas
                  12. Kidney
                  13. Prostate
                  14. Testicle
                  15. Ovary
                  16. Cervix
                  17. Endometrium
                  18. Colon or rectum
                  19. Bladder
                  20. Skin
                  21. Lymphoma
                  22. Leukemia
                  97. Other organ

            *ENDIF*
            **PH076_YearCondition** (YEAR MOST RECENT CONDITION)
              In what year was your most recent *[heart attack/ stroke or cerebral vascular disease/ cancer/ hip fracture]*?
              NUMBER [1900..2024]

                *IF (PH076_YearCondition = RESPONSE)*
                ⊟
                    **CHECK**: (NOT(PH076_YearCondition < Preload.InterviewYear_Regular)) *[Year should be greater than or equal to the year of last interview. If year is correct, please press "suppress" and enter a remark to explain.;]*
                *ENDIF*
            **PH077_MonthCondition** (MONTH MOST RECENT CONDITION)
              In what month was that?
              1. January
              2. February
              3. March
              4. April
              5. May
              6. June
              7. July
              8. August
              9. September
              10. October
              11. November
              12. December

                *IF ((PH077_MonthCondition = RESPONSE AND (PH076_YearCondition = Preload.InterviewYear_Regular))*
                ⊟
                    **CHECK**: (NOT(PH077_MonthCondition < Preload.InterviewMonth_Regular)) *[Month should be greater than or equal to the month of last interview. If month is correct, please press "suppress" and enter a remark to explain.;]*
                *ENDIF*
            **PH071_HadConditionHowMany** (HOW MANY)
              How many*[heart attacks/ strokes or cerebral vascular diseases/ cancers/ hip fractures]* have you had since we talked to you in ^FLLastInterviewMonthYear;?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 54 ---

1. 1
                     2. 2
                     3. 3 or more

        ENDIF
        [3]
        PH072_HadCondition (HAD CONDITION)
         [For a few conditions, we would like to know exactly what has happened in the past couple of years.
         ]
        Since our interview in ^FLLastInterviewMonthYear; have you[had a heart attack/ had a stroke or been diagnosed with
        cerebral vascular disease/ been diagnosed with cancer/ suffered a hip fracture]?
        1. Yes
        5. No

          IF (PH072_HadCondition = a1)
          ⊟
                IF (piIndex = 3)
                ⊟
                     |PH080_OrgCan (CANCER IN WHICH ORGANS)
                        In which organ or part of the body do you have or have you had cancer?
                        Code all that apply.;
                        1. Brain
                        2. Oral cavity
                        3. Larynx
                        4. Other pharynx
                        5. Thyroid
                        6. Lung
                        7. Breast
                        8. Oesophagus
                        9. Stomach
                        10. Liver
                        11. Pancreas
                        12. Kidney
                        13. Prostate
                        14. Testicle
                        15. Ovary
                        16. Cervix
                        17. Endometrium
                        18. Colon or rectum
                        19. Bladder
                        20. Skin
                        21. Lymphoma
                        22. Leukemia
                        97. Other organ

                ENDIF
                PH076_YearCondition (YEAR MOST RECENT CONDITION)
                 In what year was your most recent [heart attack/ stroke or cerebral vascular disease/ cancer/ hip fracture]?
                 NUMBER [1900..2024]

                  IF (PH076_YearCondition = RESPONSE)
                  ⊟
                       CHECK: (NOT(PH076_YearCondition < Preload.InterviewYear_Regular)) [Year should be greater than or equal
                       to the year of last interview. If year is correct, please press "suppress" and enter a remark to explain.;]
                  ENDIF
                PH077_MonthCondition (MONTH MOST RECENT CONDITION)
                 In what month was that?
                 1. January
                 2. February
                 3. March
                 4. April
                 5. May
                 6. June
                 7. July
                 8. August
                 9. September
                 10. October
                 11. November
                 12. December

                  IF ((PH077_MonthCondition = RESPONSE AND (PH076_YearCondition = Preload.InterviewYear_Regular))
                  ⊟
                       CHECK: (NOT(PH077_MonthCondition < Preload.InterviewMonth_Regular)) [Month should be greater than or
                       equal to the month of last interview. If month is correct, please press "suppress" and enter a remark to
                       explain.;]
                ENDIF
                PH071_HadConditionHowMany (HOW MANY)
                 How many[heart attacks/ strokes or cerebral vascular diseases/ cancers/ hip fractures] have you had since we
                 talked to you in ^FLLastInterviewMonthYear;?
                 1. 1
                 2. 2
                 3. 3 or more

          ENDIF
          [4]
        ENDIF
        PH089_Frailty_Symptoms (BOTHERED BY SYMPTOMS)
         Please look at card 8.
         For the past six months at least, have you been bothered by any of the health conditions on this card? Please tell me the
         number or numbers.
         Code all that apply.;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 55 ---

SET OF 1. Falling down
   2. Fear of falling down
   3. Dizziness, faints or blackouts
   4. Fatigue
   96. None

**CHECK**: (NOT((count(PH089_Frailty_Symptoms) > 1 AND ((96 IN (PH089_Frailty_Symptoms))))) *[You cannot select '96' together with any other answer. Please change your answer.;]*
**PH084_TroubledPain** (TROUBLED BY PAIN)
   Are you troubled with pain?
   1. Yes
   5. No

     *IF (PH084_TroubledPain = a1)*
     ⊟
         **PH085_PainLevel** (HOW BAD PAIN)
              How bad is the pain most of the time? Is it..
              Read out.;
              1. Mild
              3. Moderate
              5. Severe

         **PH087_PainJointLoc** (SIX MONTHS BOTHERED BY PAIN)
              Look at card 9.
              In which parts of the body do you feel pain?
              Code all that apply.;
              SET OF 1. Back
              2. Hips
              3. Knees
              4. Other joints
              5. Mouth/Teeth
              6. Other parts of the body, but not joints
              7. All over

         **CHECK**: (NOT((count(PH087_PainJointLoc) > 1 AND ((7 IN (PH087_PainJointLoc))))) *[You cannot select 'All over' together with any other answer. Please change your answer.;]*
     *ENDIF*
**PH011_CurrentDrugs** (CURRENT DRUGS AT LEAST ONCE A WEEK)
   Our next question is about the medication you may be taking. Please look at card 10. Do you currently take drugs **at least once a week** for problems mentioned on this card?
   Code all that apply.;
   SET OF 1. Drugs for high blood cholesterol
   2. Drugs for high blood pressure
   3. Drugs for coronary or cerebrovascular diseases
   4. Drugs for other heart diseases
   6. Drugs for diabetes
   7. Drugs for joint pain or for joint inflammation
   8. Drugs for other pain (e.g. headache, back pain, etc.)
   9. Drugs for sleep problems
   10. Drugs for anxiety or depression
   11. Drugs for osteoporosis
   13. Drugs for stomach burns
   14. Drugs for chronic bronchitis
   15. Drugs for suppressing inflammation (only glucocorticoids or steroids)
   96. None
   97. Other drugs, not yet mentioned

**CHECK**: (NOT((count(PH011_CurrentDrugs) > 1 AND ((96 IN (PH011_CurrentDrugs))))) *[You cannot select '96' together with any other answer. Please change your answer.;]*
   *IF (NOT((96 IN (PH011_CurrentDrugs))))*
   ⊟
         **PH082_PolyPharmacy** (AT LEAST FIVE PER DAY)
              Do you take at least five **different** drugs on a typical day?
              Please include drugs prescribed by your doctor, drugs you buy without prescription, and dietary supplements such as vitamins and minerals.
              1. Yes
              5. No

     *ENDIF*
**PH012_Weight** (WEIGHT OF RESPONDENT)
   Approximately how much do you weigh?
   Weight in kilos (in UK stone-dot-pounds)
   NUMBER [0..250]

**CHECK**: (NOT(((PH012_Weight >= 125 OR (PH012_Weight <= 40) AND (PH012_Weight = RESPONSE))) *[Please confirm: Respondent weights; TOSTRING(PH012_Weight) kilos, is that correct? If not, please correct the answer. If the answer is correct, please press Suppress and continue.;]*
**PH065_CheckLossWeight** (CHECK LOSS WEIGHT)
   Have you lost any weight during the last 12 months?
   1. Yes
   5. No

     *IF (PH065_CheckLossWeight = a1)*
     ⊟
         **PH095_HowMuchLostWeight** (HOW MUCH LOSS WEIGHT)
              How much weight did you lose?
              Only lost weight in whole KG e.g. 1 kg 2 kg 3 kg and so forth
              NUMBER [1..50]

         **PH066_ReasonLostWeight** (REASON LOST WEIGHT)
              Why did you lose weight?
              Read out.;
              1. Due to illness

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 56 ---

2. You followed a special diet
            3. Due to both illness and followed a special diet
            97. Other reasons for weight loss

        ENDIF
        IF (MN101_Longitudinal = 0)
        ⊟
            PH013_HowTall (HOW TALL ARE YOU?)
            How tall are you?
            Length in centimetres (in UK: feet-dot-inches)
            NUMBER [60..230]

            CHECK: (NOT(((PH013_HowTall >= 200 OR (PH013_HowTall <= 130) AND (PH013_HowTall = RESPONSE))) [Please confirm: Respondent measures; TOSTRING(PH013_HowTall) centimeters, is that correct? If not, please correct the answer. If the answer is correct, please press Suppress and continue.;]
        ENDIF
PH041_UseGlasses (USE GLASSES)
  Do you usually wear glasses or contact lenses?
  All types of glasses, also glasses used only for reading.
  1. Yes
  5. No

    IF (PH041_UseGlasses = a1)
    ⊟
        PH690_BifocGlasLenses (USE BIFOCAL GLASSES/LENSES)
          What type of glasses or contact lenses do you wear?
          Code all that apply.; Read out.;
          SET OF 1. Bifocals or progressive glasses or contact lenses
          2. Reading glasses or contact lenses (single vision glasses)
          3. Distance glasses or contact lenses (single vision glasses)
          4. Other glasses or contact lenses

    ENDIF
    IF ((PH041_UseGlasses = a5 OR (((a2 IN (PH690_BifocGlasLenses) AND (count(PH690_BifocGlasLenses) = 1)))
    ⊟
        PH043_EyeSightDist (EYESIGHT DISTANCE)
          How good is your eyesight for seeing things at a distance, like recognising a friend across the street[using glasses or contact lenses as usual]? Would you say it is...
          Read out.;
          1. Excellent
          2. Very good
          3. Good
          4. Fair
          5. Poor

    ELSE
    ⊟
        PH043_EyeSightDist (EYESIGHT DISTANCE)
          How good is your eyesight for seeing things at a distance, like recognising a friend across the street[using glasses or contact lenses as usual]? Would you say it is...
          Read out.;
          1. Excellent
          2. Very good
          3. Good
          4. Fair
          5. Poor

    ENDIF
    IF ((PH041_UseGlasses = a5 OR (((a3 IN (PH690_BifocGlasLenses) AND (count(PH690_BifocGlasLenses) = 1)))
    ⊟
        PH044_EyeSightPap (EYESIGHT READING)
          How good is your eyesight for seeing things up close, like reading ordinary newspaper print[using glasses or contact lenses as usual]?
          Would you say it is...
          Read out.;
          1. Excellent
          2. Very good
          3. Good
          4. Fair
          5. Poor

    ELSE
    ⊟
        PH044_EyeSightPap (EYESIGHT READING)
          How good is your eyesight for seeing things up close, like reading ordinary newspaper print[using glasses or contact lenses as usual]?
          Would you say it is...
          Read out.;
          1. Excellent
          2. Very good
          3. Good
          4. Fair
          5. Poor

    ENDIF
PH745_HaveHearingAid (HAVE HEARING AID)
  Do you have a hearing aid?
  1. Yes
  5. No

    IF (PH745_HaveHearingAid = a1)

--- page 57 ---

PH045_UseHearingAid (USE HEARING AID)
         Are you usually wearing a hearing aid?
         1. Yes
         5. No

   ENDIF
PH046_Hearing (HEARING)
   Is your hearing[using a hearing aid as usual]...
   Read out.;
   1. Excellent
   2. Very good
   3. Good
   4. Fair
   5. Poor

PH048_HeADLa (HEALTH AND ACTIVITIES)
   Please look at card 11.
   Please tell me whether you have any difficulty doing each of the everyday activities on this card. Exclude any difficulties that you expect to last less than three months.
   Probe respondent if any other difficulty applies.
   Code all that apply.;
   SET OF 1. Walking 100 metres
   2. Sitting for about two hours
   3. Getting up from a chair after sitting for long periods
   4. Climbing several flights of stairs without resting
   5. Climbing one flight of stairs without resting
   6. Stooping, kneeling, or crouching
   7. Reaching or extending your arms above shoulder level
   8. Pulling or pushing large objects like a living room chair
   9. Lifting or carrying weights over 10 pounds/5 kilos, like a heavy bag of groceries
   10. Picking up a small coin from a table
   96. None of these

CHECK: (NOT((count(PH048_HeADLa) > 1 AND ((96 IN (PH048_HeADLa)))) [You cannot select '96' together with any other answer. Please change your answer.;]
PH049_HeADLb (MORE HEALTH AND ACTIVITIES)
   Please look at card 12.
   Please tell me if you have any difficulty with these activities because of a physical, mental, emotional or memory problem. Again exclude any difficulties you expect to last less than three months.
   Probe respondent if any other difficulty applies.
   Code all that apply.;
   SET OF 1. Dressing, including putting on shoes and socks
   2. Walking across a room
   3. Bathing or showering
   4. Eating, such as cutting up your food
   5. Getting in or out of bed
   6. Using the toilet, including getting up or down
   7. Using a map to figure out how to get around in a strange place
   8. Preparing a hot meal
   9. Shopping for groceries
   10. Making telephone calls
   11. Taking medications
   12. Doing work around the house or garden
   13. Managing money, such as paying bills and keeping track of expenses
   14. Leaving the house independently and accessing transportation services
   15. Doing personal laundry
   96. None of these

CHECK: (NOT((count(PH049_HeADLb) > 1 AND ((96 IN (PH049_HeADLb)))) [You cannot select '96' together with any other answer. Please change your answer.;]
   IF (NOT(((((96 IN (PH048_HeADLa) OR (PH048_HeADLa = DontKnow) OR (PH048_HeADLa = Refusal) AND ((((96 IN (PH049_HeADLb) OR (PH049_HeADLb = DontKnow) OR (PH049_HeADLb = Refusal))))
   ⊟
         PH050_HelpAct (HELP ACTIVITIES)
            Thinking about the activities that you have problems with, does anyone ever help you with these activities?
            Including your partner or other people in your household
            1. Yes
            5. No

            IF (PH050_HelpAct = a1)
            ⊟
                  PH051_HelpMeetsN (HELP MEETS NEEDS)
                     Would you say that the help you receive meets your needs?
                     Read out.;
                     1. All the time
                     2. Usually
                     3. Sometimes
                     4. Hardly ever

               ENDIF
   ENDIF
PH059_UseAids (USE OF AIDS)
   Please look at card 13. Do you use any of the items listed on this card?
   No. 7. Only include personal alarms used to call for assistance after falls etc.
   SET OF 1. A cane or walking stick
   2. A zimmer frame or walker
   3. A manual wheelchair
   4. An electric wheelchair
   5. A buggy or scooter
   6. Special eating utensils
   7. A personal alarm

--- page 58 ---

8. Bars, grabs, rails (to facilitate movements and to keep ones balance)
         9. Raised toilet seat with/without arms
         10. Incontinence pads
         96. None of these
         97. other items (specify)

      CHECK: (NOT((count(PH059_UseAids) > 1 AND ((96 IN (PH059_UseAids)))) [You cannot select '96' together with any other
      answer. Please change your answer.;]
         IF ((a97 IN (PH059_UseAids))
         ⊟
            |PH659_UseAidsOther (USE OF AIDS)
               What other items?
               STRING

         ENDIF
      PH054_IntCheck (WHO ANSWERED THE QUESTIONS IN PH)

         CHECK:
         Who answered the questions in this section?
         1. Respondent only
         2. Respondent and proxy
         3. Proxy only

   ENDIF
   IF (((BR IN (Test) OR ((ALL IN (Test)))
   ⊟
      BR001_EverSmokedDaily (EVER SMOKED DAILY)
         The following questions are about smoking and drinking alcoholic beverages. Have you ever smoked cigarettes, cigars, cigarillos
         or a pipe daily for a period of at least one year?
         1. Yes
         5. No

         IF (BR001_EverSmokedDaily = a1)
         ⊟
            BR002_StillSmoking (SMOKE AT THE PRESENT TIME)
               Do you smoke at the present time?
               1. Yes
               5. No

            BR003_HowManyYearsSmoked (HOW MANY YEARS SMOKED)
               For how many years [have you smoked/ did you smoke] all together?
               Don't include periods without smoking.
               Code 1 if respondent smoked for less than one year.
               NUMBER [1..99]

            BR005_WhatSmoke (WHAT DO OR DID YOU SMOKE)
               What[do/ did][you][smoke/ smoke before you stopped]?
               Cigarettes include 'roll-your-own'. Read out.; Code all that apply.;
               1. Cigarettes
               2. Pipe
               3. Cigars or cigarillos
               4. E-cigarettes with nicotine solution.

               IF ((1 IN (BR005_WhatSmoke))
               ⊟
                  BR006_AmManCig (AVERAGE AMOUNT OF CIGARETTES PER DAY)
                     How many cigarettes[do/ did][you][smoke] on average per day?
                     NUMBER [0..120]

               ENDIF
         ENDIF
      BR039_Drinklastsevendays (ANY DRINK LAST SEVEN DAYS)
         During the last 7 days, have you had at least one alcoholic beverage?
         1. Yes
         5. No

         IF (BR039_Drinklastsevendays = a1)
         ⊟
            BR040_Drinklastsevendays (HOW OFTEN DRINKS LAST SEVEN DAYS)
               Please look at card 14, which shows standard units of alcoholic beverages. During the last 7 days, overall how many units
               of alcoholic beverages did you have?
               Please open the booklet and calculate the No. of units/week together with the respondent. If none, please enter '0'.
               Please round to the nearest whole number.
               NUMBER [0..200]

         ENDIF
      BR623_SixOrMoreDrinks (HOW OFTEN SIX OR MORE DRINKS LAST 3 MONTHS)
         Please look at card 15.
         In the last three months, how often did you have six or more units of alcoholic beverages on one occasion?
         Standard units of alcoholic beverages are shown at the previous card.
         1. Daily or almost daily
         2. Five or six days a week
         3. Three or four days a week
         4. Once or twice a week
         5. Once or twice a month
         6. Less than once a month
         7. Not at all in the last 3 months

      BR015_PartInVigSprtsAct (SPORTS OR ACTIVITIES THAT ARE VIGOROUS)
         We would like to know about the type and amount of physical activity you do in your daily life. How often do you engage in
         vigorous physical activity, such as sports, heavy housework, or a job that involves physical labour?
         Read out.;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 59 ---

1. More than once a week
            2. Once a week
            3. One to three times a month
            4. Hardly ever, or never

         BR016_ModSprtsAct (ACTIVITIES REQUIRING A MODERATE LEVEL OF ENERGY)
           How often do you engage in activities that require a moderate level of energy such as gardening, cleaning the car, or doing a
           walk?
           Read out.;
           1. More than once a week
           2. Once a week
           3. One to three times a month
           4. Hardly ever, or never

         BR026_DairyProd (HOW OFTEN SERVING OF DAIRY PRODUCTS)
           Please look at card 16. In a regular week, how often do you have a serving of dairy products such as a glass of milk, cheese in
           a sandwich, a cup of yogurt or a can of high protein supplement?
           1. Every day
           2. 3-6 times a week
           3. Twice a week
           4. Once a week
           5. Less than once a week

         BR027_LegumesEggs (HOW OFTEN A WEEK SERVING OF LEGUMES OR EGGS)
           (Please look at card 16.) In a regular week, how often do you have a serving of legumes, beans or eggs?
           1. Every day
           2. 3-6 times a week
           3. Twice a week
           4. Once a week
           5. Less than once a week

         BR028_MeatWeek (HOW OFTEN A DAY DO YOU EAT MEAT, FISH OR POULTRY)
           (Please look at card 16.) In a regular week, how often do you eat meat, fish or poultry?
           1. Every day
           2. 3-6 times a week
           3. Twice a week
           4. Once a week
           5. Less than once a week

           IF ((BR028_MeatWeek > a2 AND (MN032_socex = 1))
           ⊟
               BR033_MeatAfford (MEAT AFFORD)
                 Would you say that you do not eat meat, fish or poultry more often because...
                 Read out.;; If the respondent follows a vegan, fruitarian or other kind of diet without meat, fish and poultry please code
                 3.
                 1. you cannot afford to eat it more often
                 3. you follow a vegetarian diet
                 97. for other reasons

           ENDIF
         BR029_FruitsVegWeek (HOW OFTEN A WEEK DO YOU CONSUME A SERVING OF FRUITS OR VEGETABLES)
           (Please look at card 16.) In a regular week, how often do you consume a serving of fruits or vegetables?
           1. Every day
           2. 3-6 times a week
           3. Twice a week
           4. Once a week
           5. Less than once a week

         BR017_IntCheck (INTERVIEWER CHECK BR)

           CHECK:
           Who answered the questions in this section?
           1. Respondent only
           2. Respondent and proxy
           3. Proxy only

       ENDIF
       IF (((CF IN (Test) OR ((ALL IN (Test)))
       ⊟
           CF019_CFInstruct (INSTRUCTION FOR CF)

             This is the cognitive test section: while you complete this section, make sure that no third persons are present.
             Start of a non-proxy section. No proxy allowed. If the respondent is not capable of answering any of these questions on her/his
             own, press CTRL-K at each question.
             1. Continue

             IF (MN101_Longitudinal = 0)
             ⊟
                 CF001_SRRead (SELF-RATED READING SKILLS)
                   Now I would like to ask some questions about your reading and writing skills. How would you rate your reading skills
                   needed in your daily life? Would you say they are...
                   Read out.;
                   1. Excellent
                   2. Very good
                   3. Good
                   4. Fair
                   5. Poor

                 CF002_SRWrite (SELF-RATED WRITING SKILLS)
                   How would you rate your writing skills needed in your daily life? Would you say they are...
                   Read out.;
                   1. Excellent
                   2. Very good

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 60 ---

3. Good
            4. Fair
            5. Poor

  ENDIF
CF003_DateDay (DATE-DAY OF MONTH)
  Part of this study is concerned with people's memory AND ability to think about things. First, I am going to ask about today's
  date. Which day of the month is it?
  Code whether day of month (^FLDay;;) is given correctly
  1. Day of month given correctly
  2. Day of month given incorrectly/doesn't know day

CF004_DateMonth (DATE-MONTH)
  Which month is it?
  Code whether month (;) is given correctly
  1. Month given correctly
  2. Month given incorrectly/doesn't know month

CF005_DateYear (DATE-YEAR)
  Which year is it?
  Code whether year (^FLYear;) is given correctly
  1. Year given correctly
  2. Year given incorrectly/doesn't know year

CF006_DayWeek (DAY OF THE WEEK)
  Can you tell me what day of the week it is?
  Correct answer: (^FLToday;)
  1. Day of week given correctly
  2. Day of week given incorrectly/doesn't know day

CF103_Memory (SELF-RATED WRITING SKILLS)
  How would you rate your memory at the present time? Would you say it is excellent, very good, good, fair or poor?
  1. Excellent
  2. Very good
  3. Good
  4. Fair
  5. Poor

  IF ((MN101_Longitudinal = 1 AND (MN808_AgeRespondent > 59))
  ⊟
        CF820_MemoryChange (SELF-RATED MEMORY CHANGE)
        Compared to ^FLLastInterviewMonthYear;, would you say your memory is better now, about the same, or worse now
        than it was then?
        1. Better
        2. Same
        3. Worse

  ENDIF
CF007_Learn1Intro (INTRODUCTION TEN WORDS LIST LEARNING)
  Now, I am going to read a list of words from my computer screen. We have purposely made the list long so it will be difficult for
  anyone to recall all the words. Most people recall just a few. Please listen carefully, as the set of words cannot be repeated.
  When I have finished, I will ask you to recall aloud as many of the words as you can, in any order. Is this clear?
  Have booklet ready
  1. Continue

  IF (CF007_Learn1Intro = RESPONSE)
  ⊟
        IF (CF009_VerbFluIntro = Empty)
        ⊟
              CF101_Learn1 (TEN WORDS LIST LEARNING FIRST TRIAL)
              Ready?
              Wait until words appear on the screen. Write words on sheet provided. Allow up to one minute for recall. Enter the
              words respondent correctly recalls.
              1. Start test

              IF (CF102_Learn1 = Empty)
              ⊟
                    CF102_Learn1 (TEN WORDS LIST LEARNING SHOW MOVIE)
                    ;
                    1. Continue

              ENDIF
              IF (MN025_RandomCF102 = 1)
              ⊟
                    CF104_Learn1 (TEN WORDS LIST LEARNING FIRST TRIAL)
                      Now please tell me all the words you can recall.
                      SET OF 1. Hotel
                      2. River
                      3. Tree
                      4. Skin
                      5. Gold
                      6. Market
                      7. Paper
                      8. Child
                      9. King
                      10. Book
                      96. None of these

                      CHECK: (NOT((count(CF104_Learn1) > 1 AND ((96 IN (CF104_Learn1)))) [You cannot select '96' together
                      with any other answer. Please change your answer.;]
              ELSE
              ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 61 ---

IF (MN025_RandomCF102 = 2)
   ⊟
      CF105_Learn1 (TEN WORDS LIST LEARNING FIRST TRIAL)
         Now please tell me all the words you can recall.
         SET OF 1. Sky
         2. Ocean
         3. Flag
         4. Dollar
         5. Wife
         6. Machine
         7. Home
         8. Earth
         9. College
         10. Butter
         96. None of these

         CHECK: (NOT((count(CF105_Learn1) > 1 AND ((96 IN (CF105_Learn1)))) [You cannot select '96' together with any other answer. Please change your answer.;]
      ELSE
      ⊟
         IF (MN025_RandomCF102 = 3)
         ⊟
            CF106_Learn1 (TEN WORDS LIST LEARNING FIRST TRIAL)
               Now please tell me all the words you can recall.
               SET OF 1. Woman
               2. Rock
               3. Blood
               4. Corner
               5. Shoes
               6. Letter
               7. Girl
               8. House
               9. Valley
               10. Engine
               96. None of these

               CHECK: (NOT((count(CF106_Learn1) > 1 AND ((96 IN (CF106_Learn1)))) [You cannot select '96' together with any other answer. Please change your answer.;]
            ELSE
            ⊟
               IF (MN025_RandomCF102 = 4)
               ⊟
                  CF107_Learn1 (TEN WORDS LIST LEARNING FIRST TRIAL)
                     Now please tell me all the words you can recall.
                     SET OF 1. Water
                     2. Church
                     3. Doctor
                     4. Palace
                     5. Fire
                     6. Garden
                     7. Sea
                     8. Village
                     9. Baby
                     10. Table
                     96. None of these

                     CHECK: (NOT((count(CF107_Learn1) > 1 AND ((96 IN (CF107_Learn1)))) [You cannot select '96' together with any other answer. Please change your answer.;]
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF
CF009_VerbFluIntro (VERBAL FLUENCY INTRO)
   Now I would like you to name as many different animals as you can think of. You have one minute to do this.

Ready, go.
Allow one minute precisely. If the respondent stops before the end of the time, encourage him/her to try to find more words. If he/she is silent for 15 seconds repeat the basic instruction ('I want you to tell me all the animals you can think of'). No extension on the time limit is made in the event that the instruction has to be repeated.
1. Continue

   IF (CF009_VerbFluIntro = RESPONSE)
   ⊟
      IF (CF810_AnimalsVideo = Empty)
      ⊟
         CF810_AnimalsVideo (VERBAL FLUENCY SCORE)
            2;
            The score is the sum of acceptable animals. Any member of the animal kingdom, real or mythical is scored correct, except repetitions and proper nouns. Specifically each of the following gets credit: a species name and any accompanying breeds within the species; male, female and infant names within the species.
            1. Continue

      ENDIF
   ENDIF
   IF (CF009_VerbFluIntro = RESPONSE)
   ⊟
      CF010_Animals (VERBAL FLUENCY SCORE)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 62 ---

The score is the sum of acceptable animals. Any member of the animal kingdom, real or mythical is scored correct, except repetitions and proper nouns. Specifically each of the following gets credit: a species name and any accompanying breeds within the species; male, female and infant names within the species. Code number of animals (0..100)
NUMBER [0..100]

ENDIF
IF (MN101_Longitudinal = 0)
   CF011_IntroNum (INTRODUCTION NUMERACY)
      Next I would like to ask you some questions which assess how people use numbers in everyday life.
      If necessary, encourage the respondent to try to answer each of the numeracy questions
      1. Continue

   CF012_NumDis (NUMERACY-CHANCE DISEASE 10 PERC. OF 1000)
      If the chance of getting a disease is 10 percent, how many people out of 1000 (one thousand) would be expected to get the disease?
      Do not read out the answers
      1. 100
      2. 10
      3. 90
      4. 900
      97. Other answer

      IF (CF012_NumDis <> a1)
         CF013_NumHalfPrice (NUMERACY-HALF PRICE)
            In a sale, a shop is selling all items at half price. Before the sale, a sofa costs 300 ^FLCurr;. How much will it cost in the sale?
            Do not read out the answers
            1. 150 ^FLCurr;
            2. 600 ^FLCurr;
            97. Other answer

      ENDIF
      IF (CF012_NumDis = a1)
         CF014_NumCar (NUMERACY-6000 IS TWO-THIRDS WHAT IS TOTAL PRICE)
            A second hand car dealer is selling a car for 6,000 ^FLCurr;. This is two-thirds of what it costs new. How much did the car cost new?
            Do not read out the answers
            Paper and pencil should not be used by the respondent.
            1. 9,000 ^FLCurr;
            2. 4,000 ^FLCurr;
            3. 8,000 ^FLCurr;
            4. 12,000 ^FLCurr;
            5. 18,000 ^FLCurr;
            97. Other answer

            IF (CF014_NumCar = a1)
               CF015_Savings (AMOUNT IN THE SAVINGS ACCOUNT)
                  Let's say you have 2000 ^FLCurr; in a savings account. The account earns ten per cent interest each year. How much would you have in the account at the end of two years?
                  Do not read out the answers
                  1. 2420 ^FLCurr;
                  2. 2020 ^FLCurr;
                  3. 2040 ^FLCurr;
                  4. 2100 ^FLCurr;
                  5. 2200 ^FLCurr;
                  6. 2400 ^FLCurr;
                  97. Other answer

            ENDIF
      ENDIF
ENDIF
CF108_Serial (NUMERACY-SUBTRACTION 1)
Now let's try some subtraction of numbers. One hundred minus 7 equals what?
Paper and pencil should not be used by the respondent.
If R adds 7 instead, you may repeat question.
NUMBER

IF ((CF108_Serial < 99999998 AND (NOT((CF108_Serial = Refusal OR (CF108_Serial = DontKnow))))
   CF109_Serial (NUMERACY-SUBTRACTION 2)
      And 7 from that
      This is the second subtraction
      NUMBER

      IF ((CF109_Serial < 99999998 AND (NOT((CF109_Serial = Refusal OR (CF109_Serial = DontKnow))))
         CF110_Serial (NUMERACY-SUBTRACTION 3)
            And 7 from that
            This is the third subtraction
            NUMBER

            IF ((CF110_Serial < 99999998 AND (NOT((CF110_Serial = Refusal OR (CF110_Serial = DontKnow))))
               CF111_Serial (NUMERACY-SUBTRACTION 4)
                  And 7 from that
                  This is the fourth subtraction

--- page 63 ---

NUMBER

IF ((CF111_Serial < 99999998 AND (NOT((CF111_Serial = Refusal OR (CF111_Serial = DontKnow))))
   ⊟
      CF112_Serial (NUMERACY-SUBTRACTION 5)
         And 7 from that
         This is the fifth subtraction
         NUMBER

         ENDIF
      ENDIF
   ENDIF
ENDIF
IF (CF007_Learn1Intro = RESPONSE)
⊟
      IF (CF101_Learn1 <> Refusal)
      ⊟
         IF (MN025_RandomCF102 = 1)
         ⊟
            CF113_Learn4 (TEN WORDS LIST LEARNING DELAYED RECALL)
               A little while ago, I read you a list of words and you repeated the ones you could remember. Please tell me
               any of the words that you can remember now?
               Write words on sheet provided. Allow up to one minute for recall. Enter the words respondent correctly
               recalls.
               SET OF 1. Hotel
               2. River
               3. Tree
               4. Skin
               5. Gold
               6. Market
               7. Paper
               8. Child
               9. King
               10. Book
               96. None of these

            CHECK: (NOT((count(CF113_Learn4) > 1 AND ((96 IN (CF113_Learn4)))) [You cannot select '96' together
            with any other answer. Please change your answer.;]
         ELSE
         ⊟
            IF (MN025_RandomCF102 = 2)
            ⊟
               CF114_Learn4 (TEN WORDS LIST LEARNING DELAYED RECALL)
                  A little while ago, I read you a list of words and you repeated the ones you could remember. Please
                  tell me any of the words that you can remember now?
                  Write words on sheet provided. Allow up to one minute for recall. Enter the words respondent
                  correctly recalls.
                  SET OF 1. Sky
                  2. Ocean
                  3. Flag
                  4. Dollar
                  5. Wife
                  6. Machine
                  7. Home
                  8. Earth
                  9. College
                  10. Butter
                  96. None of these

               CHECK: (NOT((count(CF114_Learn4) > 1 AND ((96 IN (CF114_Learn4)))) [You cannot select '96'
               together with any other answer. Please change your answer.;]
            ELSE
            ⊟
               IF (MN025_RandomCF102 = 3)
               ⊟
                  CF115_Learn4 (TEN WORDS LIST LEARNING DELAYED RECALL)
                     A little while ago, I read you a list of words and you repeated the ones you could remember.
                     Please tell me any of the words that you can remember now?
                     Write words on sheet provided. Allow up to one minute for recall. Enter the words respondent
                     correctly recalls.
                     SET OF 1. Woman
                     2. Rock
                     3. Blood
                     4. Corner
                     5. Shoes
                     6. Letter
                     7. Girl
                     8. House
                     9. Valley
                     10. Engine
                     96. None of these

                  CHECK: (NOT((count(CF115_Learn4) > 1 AND ((96 IN (CF115_Learn4)))) [You cannot select
                  '96' together with any other answer. Please change your answer.;]
               ELSE
               ⊟
                  CF116_Learn4 (TEN WORDS LIST LEARNING DELAYED RECALL)
                     A little while ago, I read you a list of words and you repeated the ones you could remember.
                     Please tell me any of the words that you can remember now?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 64 ---

Write words on sheet provided. Allow up to one minute for recall. Enter the words respondent
correctly recalls.
SET OF 1. Water
2. Church
3. Doctor
4. Palace
5. Fire
6. Garden
7. Sea
8. Village
9. Baby
10. Table
96. None of these

CHECK: (NOT((count(CF116_Learn4) > 1 AND ((96 IN (CF116_Learn4)))) [You cannot select
'96' together with any other answer. Please change your answer.;]
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF ((MN101_Longitudinal = 1 AND (MN808_AgeRespondent > 59))
   ⊟
      CF821_CountingBackIntro1 (COUNTING BACKWARDS INTRO 1)
      For this next question, please try to count backward as quickly as you can from the number I will give you. I will tell you
      when to stop.

      Please start with: 20.
      Select '1. Continue' as soon as you read the number.
      1. Continue

      CF822_CountingBackTrial1 (COUNTING BACKWARDS TRIAL 1 END)

      Select '1. Continue' as soon as R has counted 10 numbers, or stops, or asks to start over.
      1. Continue

      CF823_CountingBackStop1 (COUNTING BACKWARDS STOP 1)
      You may stop now. Thank you.
      Code correct if R counted backwards from 19 to 10 or from 20 to 11 without error.
      Allow R to start over if [he/ she] wishes to do so.
      1. Correct
      5. Incorrect
      6. Wants to start over

        IF (CF823_CountingBackStop1 = 6)
        ⊟
            CF824_CountingBackIntro2 (COUNTING BACKWARDS INTRO 2)
            Let's try again.

            The number to count backward from is: 20.
            Select '1. Continue' as soon as you read the number.

            CF825_CountingBackTrial2 (COUNTING BACKWARDS TRIAL 2 END)

            Select '1. Continue' as soon as R has counted 10 numbers, or stops.

            CF826_CountingBackStop2 (COUNTING BACKWARDS STOP 2)
            You may stop now. Thank you.
            Code correct if R counted backwards from 19 to 10 or from 20 to 11 without error.
            1. Correct
            5. Incorrect

        ENDIF
        IF (MN808_AgeRespondent > 64)
        ⊟
            CF827_ObjectScissors (OBJECT SCISSORS)
            Now I'm going to ask you for the names of some things.

            What do people usually use to cut paper?
            Accept answers that are correct in the country or region.
            1. Correctly described (scissors, shears, etc.)
            5. Not correct

            CF828_ObjectCactus (OBJECT CACTUS)
            What do you call the kind of prickly plant that grows in the desert?
            Accept answers that are correct in the country or region.
            1. Correctly described (cactus or name of kind of cactus)
            5. Not correct

            CF829_ObjectPharmacy (OBJECT PHARMACY)

            Where do people usually go to buy medicine?

            Accept answers that are correct in the country or region.
            1. Correctly described (pharmacy, chemist, etc.)
            5. Not correct

        ENDIF
      CF830_DrawInfinity (DRAW INFINITY)
      Please look at card 17. Next I want you to please copy this diagram.
      Open a blank page in the recording booklet and hand it over to the R. R may correct mistakes while drawing. If the R
      does not like the first drawing and would like to do it again, you can allow for that and score the second diagram.
      Scoring: Copy is correct if both infinity loops come to a point/cross and do not look like circles.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 65 ---

1. Correct copy;
5. Incorrect copy;
7. Drawing is impossible due to physical reasons (e.g. trembling hands, poor eyesight)

**CF831_DrawCube** (DRAW CUBE)
   Please look at card 18. Now, please copy this drawing.
   Open another blank page of the recording booklet and hand it over to the R. R may correct mistakes while drawing. If the
   R does not like the first drawing and would like to do it again, you can allow for that and score the second drawing.
   1. Fully correct copy. The cube has 12 lines even if the proportions are not perfect ;
   2. Partially correct copy. The cube has fewer than 12 lines but a general cube shape is maintained ;
   5. Incorrect copy
   7. Drawing is impossible due to physical reasons (e.g. trembling hands, poor eyesight)

**CF832_DrawClockFaceIntro** (DRAW CLOCK FACE INTRO)
   And now, please draw a clock face with numbers but leave away the hands for now.
   Open another blank page of the recording booklet and hand it over to the R. Select '1. Continue' when the clock and face
   are ready or when the R stops. R may correct mistakes while drawing. If the R does not like the first drawing and would
   like to do it again, you can allow for that and score the second drawing.
   1. Continue

**CF833_DrawClockFaceAllCorrect** (DRAW CLOCK FACE ALL CORRECT)

   DO NOT READ OUT: Please score:
   Is there a reasonable circle and are the 12 numbers well distributed within the circle?
   Correct examples:  ;
   1. Yes
   5. No
   7. Drawing is impossible due to physical reasons (e.g. trembling hands, poor eyesight)

   *IF (CF833_DrawClockFaceAllCorrect = a5)*
   ⊟
        **CF834_DrawClockFace_12** (DRAW CLOCK FACE 12)

           DO NOT READ OUT: Please score:
           Are all 12 numbers included? It doesn't matter if they are poorly distributed or outside of the circle.

           Correct examples: ;
           1. Yes
           5. No

           *IF (CF834_DrawClockFace_12 = a5)*
           ⊟
                **CF835_DrawClockFace_Circle** (DRAW CLOCK FACE CIRCLE)

                   DO NOT READ OUT: Please score:
                   Was there a reasonable circle?
                   1. Yes
                   5. No

           *ENDIF*
   *ENDIF*
   *IF (((CF833_DrawClockFaceAllCorrect = a1 OR (CF834_DrawClockFace_12 = a1) OR (CF835_DrawClockFace_Circle =
a1))*
   ⊟
        **CF836_DrawClockHands** (DRAW CLOCK HANDS)
           And now, please put the hands at ten past five.
           Select '1. Continue' when the hands are drawn or when the R stops.
           1. Continue

        **CF837_DrawClockHandsAllCorrect** (DRAW CLOCK HANDS ALL CORRECT)

           DO NOT READ OUT: Please score:
           Are both hands well drawn? That means: Do they have different lengths and are placed on correct numbers? You
           might ask which one is the small and big one.

           Correct example:;
           1. Yes
           5. No

           *IF (CF837_DrawClockHandsAllCorrect = a5)*
           ⊟
                **CF838_DrawClockHands2Hands_LengthIncorrect** (DRAW CLOCK HANDS 2 HANDS LENGTH INCORRECT)

                   DO NOT READ OUT: Please score:
                   Are both hands placed on the correct numbers but the lengths are interchanged?
                   1. Yes
                   5. No

                   *IF (CF838_DrawClockHands2Hands_LengthIncorrect = a5)*
                   ⊟
                        **CF839_DrawClockHands1HandCorrect** (DRAW CLOCK HANDS 1 HAND CORRECT)

                           DO NOT READ OUT: Please score:
                           Is one hand placed on the correct number and drawn with correct length? It doesn't matter if the
                           second hand is missing or is drawn incorrectly.

                           Correct examples:  ;
                           1. Yes
                           5. No

                   *ENDIF*
           *ENDIF*

--- page 66 ---

| *ENDIF*
   *ENDIF*
**CF017_Factors** (CONTEXTUAL FACTORS DURING THE COGNITIVE FUNCTION TEST)

   Were there any factors that may have impaired the respondent's performance on the tests?
   If you want to comment, use CTRL+M
   1. Yes
   5. No

**CF018_IntCheck** (WHO WAS PRESENT DURING CF)

   INTERVIEWER CHECK: WHO WAS PRESENT DURING THIS SECTION?

   Code all that apply.;
   1. Respondent alone
   2. Partner present
   3. Child(ren) present
   4. Other(s)

**CHECK**: (NOT((count(CF018_IntCheck) > 1 AND ((a1 IN (CF018_IntCheck)))) *[Cannot select -respondent alone- with any other category;]*
**CHECK**: (NOT((Sec_CH.NumberOFReportedChildren = 0 AND ((a3 IN (CF018_IntCheck)))) *[You answered earlier you had no children;]*
**CF719_EndNonProxy** (NON PROXY)

   CHECK: Who answered the questions in this section?
   1. Respondent
   2. Section not answered (proxy interview)

   *IF (CF719_EndNonProxy = 2)*
   ⊟
      **CF840_ProxyIntro** (PROXY INTRO)

         Please turn to the PROXY respondent and ask him/her directly about the cognitive abilities of the R.
         The following questions should be answered by the proxy respondent in private, without the presence of the R or any other people.
         This part will take about 2 minutes.
         1. Continue

      **CF841_ProxyMemory** (PROXY MEMORY)
         Now I would like to ask some questions to you (as the one who answers on behalf of the Respondent).
         Part of this study is concerned with people's memory, and ability to think about things.

         First, how would you rate ^FLRespondentName;'s memory at the present time? Would you say it is excellent, very good, good, fair or poor?
         1. Excellent
         2. Very good
         3. Good
         4. Fair
         5. Poor

      **CF842_ProxyMemoryChange** (PROXY MEMORY CHANGE)
         Compared to two years ago, would you say ^FLRespondentName;'s memory is better now, about the same, or worse now than it was then?
         1. Better
         2. Same
         3. Worse

      **CF843_ProxyMemoryFamily** (PROXY MEMORY FAMILY)
         Compared with two years ago, how is ^FLRespondentName; at:
         Remembering things about family and friends, such as occupations, birthdays, and addresses. Has this improved, not much changed, or gotten worse?
         1. Improved
         2. Not much changed
         3. Gotten worse
         4. Does not apply; R doesn't do activity

      **CF844_ProxyMemoryEvents** (PROXY MEMORY EVENTS)
         Compared with two years ago, how is ^FLRespondentName; at:
         Remembering things that have happened recently?
         (Has this improved, not much changed, or gotten worse?)
         1. Improved
         2. Not much changed
         3. Gotten worse
         4. Does not apply; R doesn't do activity

      **CF845_ProxyMemoryConversations** (PROXY MEMORY CONVERSATIONS)
         Compared with two years ago, how is ^FLRespondentName; at:
         Recalling conversations a few days later?
         (Has this improved, not much changed, or gotten worse?)
         1. Improved
         2. Not much changed
         3. Gotten worse
         4. Does not apply; R doesn't do activity

      **CF846_ProxyMemoryDate** (PROXY MEMORY DATE)
         Compared with two years ago, how is ^FLRespondentName; at:
         Remembering what day and month it is?
         (Has this improved, not much changed, or gotten worse?)
         1. Improved
         2. Not much changed
         3. Gotten worse
         4. Does not apply; R doesn't do activity

--- page 67 ---

CF847_ProxyMemoryLearning (PROXY MEMORY LEARNING)
   Compared with two years ago, how is ^FLRespondentName; at:
   Learning new things in general?
   (Has this improved, not much changed, or gotten worse?)
   1. Improved
   2. Not much changed
   3. Gotten worse
   4. Does not apply; R doesn't do activity

CF848_ProxyMemoryDecisions (PROXY MEMORY DECISIONS)
   Compared with two years ago, how is ^FLRespondentName; at:
   Handling money for shopping?
   (Has this improved, not much changed, or gotten worse?)
   1. Improved
   2. Not much changed
   3. Gotten worse
   4. Does not apply; R doesn't do activity

CF849_ProxyMemoryFinances (PROXY MEMORY FINANCES)
   Compared with two years ago, how is ^FLRespondentName; at:
   Handling financial matters, that is, [his/ her] pension or dealing with the bank?
   (Has this improved, not much changed, or gotten worse?)
   1. Improved
   2. Not much changed
   3. Gotten worse
   4. Does not apply; R doesn't do activity

CF850_ProxyGettingLost (PROXY GETTING LOST)
   Now, (thinking about some current behaviors,) does [he/ she] ever get lost in a familiar environment?
   1. Yes
   5. No

CF851_ProxyWanderOff (PROXY WANDER OFF)
   Does [he/ she] ever wander off and not return by [himself/ herself]?
   1. Yes
   5. No

CF852_ProxyLeftAlone (PROXY LEFT ALONE)
   Can [he/ she] be left alone for an hour or so?
   1. Yes
   5. No

CF853_ProxyNonExisting (PROXY NON EXISTING)
   Does [he/ she] ever see or hear things that are not really there?
   1. Yes
   5. No

CF854_End_proxy (END PROXY)

   This is the end of the questions asked in private to the proxy respondent.
   1. Continue

CF855_Who_present (WHO PRESENT)

   Check who was present during this section in addition to the proxy.
   Code all that apply.;
   1. PROXY respondent alone
   2. Respondent present
   3. Partner present
   4. Child(ren) present
   5. Other(s)

CHECK: (NOT((count(CF855_Who_present) > 1 AND ((a1 IN (CF855_Who_present)))) [Cannot select -respondent alone- with any other categoryProxy;]
      ENDIF
   ENDIF
IF (((MH IN (Test) OR ((ALL IN (Test)))
⊟
   MH001_Intro (INTRO MENTAL HEALTH)
      Earlier we talked about your physical health. Another measure of health is your emotional health or well being -- that is, how you feel about things that happen around you.
      Start of a Non-proxy section. No proxy allowed. If the respondent is not present or not capable to give consent to participation on her/his own, press CTRL-K at each question.
      1. Continue

   MH002_Depression (DEPRESSION)
      In the last month, have you been sad or depressed?
      If participant asks for clarification, say 'by sad or depressed, we mean miserable, in low spirits, or blue'
      1. Yes
      5. No

   MH003_Hopes (HOPES FOR THE FUTURE)
      What are your hopes for the future?
      Note only whether hopes are mentioned or not
      1. Any hopes mentioned
      2. No hopes mentioned

   MH004_WishDeath (FELT WOULD RATHER BE DEAD)
      In the last month, have you felt that you would rather be dead?
      1. Any mention of suicidal feelings or wishing to be dead
      2. No such feelings

   MH005_Guilt (FEELS GUILTY)
      Do you tend to blame yourself or feel guilty about anything?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 68 ---

1. Obvious excessive guilt or self-blame
2. No such feelings
3. Mentions guilt or self-blame, but it is unclear if these constitute obvious or excessive guilt or self-blame

  IF (MH005_Guilt = a3)
  ⊟
      MH006_BlameForWhat (BLAME FOR WHAT)
          So, for what do you blame yourself?
          Note - Only code 1 for an exaggerated feeling of guilt, which is clearly out of proportion to the circumstances. The fault
          will often have been very minor, if there was one at all. Justifiable or appropriate guilt should be coded 2.
          1. Example(s) given constitute obvious excessive guilt or self-blame
          2. Example(s) do not constitute obvious excessive guilt or self-blame, or it remains unclear if these constitute obvious or
          excessive guilt or self-blame

  ENDIF
MH007_Sleep (TROUBLE SLEEPING)
  Have you had trouble sleeping recently?
  1. Trouble with sleep or recent change in pattern
  2. No trouble sleeping

MH008_Interest (LESS OR SAME INTEREST IN THINGS)
  In the last month, what is your interest in things?
  1. Less interest than usual mentioned
  2. No mention of loss of interest
  3. Non-specific or uncodeable response

  IF (MH008_Interest = a3)
  ⊟
      MH009_KeepUpInt (KEEPS UP INTEREST)
          So, do you keep up your interests?
          1. Yes
          5. No

  ENDIF
MH010_Irritability (IRRITABILITY)
  Have you been irritable recently?
  1. Yes
  5. No

MH011_Appetite (APPETITE)
  What has your appetite been like in the last month?
  1. Diminution in desire for food
  2. No diminution in desire for food
  3. Non-specific or uncodeable response

  IF (MH011_Appetite = a3)
  ⊟
      MH012_EatMoreLess (EATING MORE OR LESS)
          So, have you been eating more or less than usual?
          1. Less
          2. More
          3. Neither more nor less

  ENDIF
MH013_Fatigue (FATIGUE)
  In the last month, have you had too little energy to do the things you wanted to do?
  1. Yes
  5. No

MH014_ConcEnter (CONCENTRATION ON ENTERTAINMENT)
  How is your concentration? For example, can you concentrate on a television programme, film or radio programme?
  1. Difficulty in concentrating on entertainment
  2. No such difficulty mentioned

MH015_ConcRead (CONCENTRATION ON READING)
  Can you concentrate on something you read?
  1. Difficulty in concentrating on reading
  2. No such difficulty mentioned

MH016_Enjoyment (ENJOYMENT)
  What have you enjoyed doing recently?
  1. Fails to mention any enjoyable activity
  2. Mentions ANY enjoyment from activity

MH017_Tear (TEARFULNESS)
  In the last month, have you cried at all?
  1. Yes
  5. No

MH033_Intro (INTRODUCTION HOW MUCH YOU FEEL)
  I will now read some statements and would like to ask you to answer how much of the time you feel certain ways: often, some
  of the time, hardly ever or never.
  1. Continue

MH034_companionship (HOW OFTEN LACK COMPANIONSHIP)
  How much of the time do you feel you lack companionship?
  Read out.;
  1. Often
  2. Some of the time
  3. Hardly ever or never

MH035_LeftOut (HOW OFTEN LEFT OUT)
  How much of the time do you feel left out?
  Repeat if necessary

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 69 ---

1. Often
         2. Some of the time
         3. Hardly ever or never

         **MH036_Isolated** (HOW OFTEN ISOLATED)
           How much of the time do you feel isolated from others?
           Repeat if necessary
           1. Often
           2. Some of the time
           3. Hardly ever or never

         **MH037_lonely** (HOW OFTEN LONELY)
           How much of the time do you feel lonely?
           Repeat if necessary
           1. Often
           2. Some of the time
           3. Hardly ever or never

         **MH032_EndNonProxy** (NON PROXY)

           CHECK: Who answered the questions in this section?
           1. Respondent
           2. Section not answered (proxy interview)

       *ENDIF*
       *IF (((HC IN (Test) OR ((ALL IN (Test)))*
       ▭
         **HC801_Intro** (INTRO HEALTH CARE)
           Now we have some questions about your doctor visits and your health insurance coverage.
           1. Continue

         **HC125_Satisfaction_with_Insurance** (SATISFACTION WITH INSURANCE)
           Let us begin with your health insurance. Overall, how satisfied are you with your own coverage in your basic health
           insurance/national health system? Are you
           Read out.;
           1. Very satisfied
           2. Somewhat satisfied
           3. Somewhat dissatisfied
           4. Very dissatisfied

         **HC113_SuppHealthInsurance** (ANY SUPPLEMENTARY HEALTH INSURANCE)
           Do you have any supplementary health insurance that pays for health services not covered by your basic health
           insurance/national health system/ third party payer? These services may include in-patient services, health examinations, office
           visits, dental care, other treatments or drugs.
           1. Yes
           5. No

         **HC116_LongTermCareInsurance** (HAS LONGTERM CARE INSURANCE)
           Do you have any of the following public or private long-term care insurances?
           Read out.; Code all that apply.;
           If unclear, explain: Long-term care insurance helps cover the cost of long-term care. It generally covers home care, assisted
           living, adult daycare, respite care, hospice care, and stays in nursing homes or residential care facilities. Some of the long-term
           care services might be covered by your health insurance.
           1. Public
           2. Private mandatory
           3. Private voluntary/supplementary
           96. None

         **CHECK**: (NOT((count(HC116_LongTermCareInsurance) > 1 AND ((a96 IN (HC116_LongTermCareInsurance)))) *[You cannot select '96' together with any other answer. Please change your answer.;]*
         **HC602_STtoMDoctor** (SEEN OR TALKED TO MEDICAL DOCTOR)
           During the last 12 months, that is since ^FLLastYearMonth;, about how many times in total have you seen or talked to a
           medical doctor or qualified/registered nurse about your health? Please exclude dentist visits and hospital stays, but include
           emergency room or outpatient clinic visits.
           Please also count contacts by telephone or other means, including those made on your behalf by a member of your family.
           NUMBER [0..366]

           *IF (HC602_STtoMDoctor > 0)*
           ▭
             **HC876_ContactsGP** (HOW MANY TIMES SEEN GP)
               How many of these contacts were with a general practitioner or with a doctor at your health care center?
               General practitioners are primary care physicians, who treat all acute and chronic diseases, and who people generally visit
               in the first instance.
               Please also count contacts by telephone or other means, including those made on your behalf by a member of your
               family.
               NUMBER [0..366]

               **CHECK**: (NOT(HC876_ContactsGP > HC602_STtoMDoctor)) *[The number cannot be higher than the overall number of contacts.;]*
             **HC877_ContactsSpecialist** (HOW MANY TIMES SEEN SPECIALIST)
               How many of these contacts were with a specialist, excluding dentist and emergency visits?
               Specialist doctors could be for instance ophthalmologist, gynecologist, cardiologist, psychiatrist, rheumatologist,
               orthopedist, ENT specialist, geriatrician, neurologist, gastroenterologist, radiologist... Please also count contacts by
               telephone or other means, including those made on your behalf by a member of your family.
               NUMBER [0..366]

               **CHECK**: (NOT(HC877_ContactsSpecialist > HC602_STtoMDoctor)) *[The number cannot be higher than the overall number of contacts.;]*
           *ENDIF*
         **HC884_Flu** (FLU)
           In the last year, that is since ^FLLastYearMonth;, did you have a flu vaccination?
           1. Yes
           5. No

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 70 ---

HC885_EyeExam (EYE EXAM LAST 24 MONTHS)
   In the last two years, that is since ^FLTwoYearsBackMonth;, have you had an eye exam performed by an eye care professional
   such as an ophthalmologist or optometrist?
   1. Yes
   5. No

   IF (MN002_Person[1].Gender = a2)
   ⊟
      |HC886_Mammogram (MAMMOGRAM)
         In the last two years, that is since ^FLTwoYearsBackMonth;, have you had a mammogram (x-ray of the breast)?
         1. Yes
         5. No

   ENDIF
HC887_ColonCancerScreening (COLON CANCER SCREENING LAST 24 MONTHS)
   Some health care providers do tests such as test for detecting hidden blood in your stool, sigmoidoscopy or colonoscopy to
   check for colon cancer. In the past two years, that is since ^FLTwoYearsBackMonth;, have you had any of these tests?
   1. Yes
   5. No

HC010_SNaDentist (SEEN A DENTIST/DENTAL HYGIENIST)
   During the last twelve months, that is since ^FLLastYearMonth;, have you seen a dentist or a dental hygienist?
   Visits for routine controls, for dentures and stomatology consultations included
   1. Yes
   5. No

HC012_PTinHos (IN HOSPITAL LAST 12 MONTHS)
   During the last twelve months, that is since ^FLLastYearMonth;, have you been in a hospital overnight? Please consider stays in
   medical, surgical, psychiatric or in any other specialised wards.
   1. Yes
   5. No

   IF (HC012_PTinHos = a1)
   ⊟
      |HC013_TiminHos (TIMES BEING PATIENT IN HOSPITAL)
         How many times have you been a patient in a hospital overnight during the last twelve months?
         Count separate occasions only.
         NUMBER [1..365]

         IF (HC013_TiminHos = 1)
         ⊟
            |HC888_TypeHos (TYPE HOSPITALISATION ONCE)
               Was this stay in hospital planned or was it an emergency?
               1. Planned
               2. Emergency

         ELSE
         ⊟
               IF (HC013_TiminHos > 1)
               ⊟
                  |HC890_TypeHosSeveral (TYPE HOSPITALISATION MORE THAN ONCE)
                     Were these stays in hospital all planned, or were they all emergencies, or both?
                     1. Planned
                     2. Emergency
                     3. Both

               ENDIF
         ENDIF
      HC014_TotNightsinPT (TOTAL NIGHTS STAYED IN HOSPITAL)
         How many nights altogether have you spent in hospitals during the last twelve months?
         NUMBER [1..365]

   ENDIF
HC064_InOthInstLast12Mon (IN OTHER INSTITUTIONS LAST 12 MONTHS)
   During the last twelve months, have you been a patient overnight in any health care facility other than a hospital, for instance in
   institutions for medical rehabilitation, convalescence, etc.? Please do not include stays in nursing homes/residential care
   facilities.
   1. Yes
   5. No

   IF (HC064_InOthInstLast12Mon = a1)
   ⊟
      HC066_TotNightStayOthInst (TOTAL NIGHTS STAYED IN OTHER INSTITUTIONS)
         How many nights altogether have you spent in any institution other than a hospital or a nursing home during the last
         twelve months?
         NUMBER [1..365]

   ENDIF
HC841_ForgoCareCost (FORGONE CARE DUE TO COST)
   Please look at card 19. During the last twelve months, which of the following types of care did you forgo because of the costs
   you would have to pay, if any?
   Code all that apply.;
   SET OF 1. Care from a general practitioner
   2. Care from a specialist physician
   3. Drugs
   4. Dental care
   5. Optical care
   6. Professional help with medical or personal care
   7. Professional help for domestic tasks at home
   96. None of these
   97. Any other care not mentioned on this list

--- page 71 ---

CHECK: (NOT((count(HC841_ForgoCareCost) > 1 AND ((a96 IN (HC841_ForgoCareCost)))) [You cannot select '96' together with any other answer. Please change your answer.;]
HC843_ForgoCareUnav (FORGONE CARE DUE TO UNAVAILABILITY)
   Please look at card 19. During the last twelve months, which of the following types of care did you forgo because they were not
   available or not easily accessible, if any?
   Code all that apply.;
   'Available/easily accessible' means reasonably close to home, open at reasonable hours and with reasonable wait times to get an
   appointment (from respondent's view point).
   SET OF 1. Care from a general practitioner
   2. Care from a specialist physician
   3. Drugs
   4. Dental care
   5. Optical care
   6. Professional help with medical or personal care
   7. Professional help for domestic tasks at home
   96. None of these
   97. Any other care not mentioned on this list

CHECK: (NOT((count(HC843_ForgoCareUnav) > 1 AND ((a96 IN (HC843_ForgoCareUnav)))) [You cannot select '96' together with any other answer. Please change your answer.;]
HC889_HealthLiteracy (LEVEL OF HEALTH LITERACY)
   How often do you need to have someone help you when you read instructions, pamphlets, or other written material from your
   doctor or pharmacy?
   1. Always
   2. Often
   3. Sometimes
   4. Rarely
   5. Never

   IF (MN024_NursingHome = a1)
   ⊟
      HC127_AtHomeCare (TYPE OF HOME CARE)
      We already talked about the difficulties you may have with various activities because of a health problem. Please look at
      card 20. During the last twelve months, that is since ^FLLastYearMonth;, did you receive in your own home any
      professional or paid services listed on this card due to a physical, mental, emotional or memory problem?
      Code all that apply.;
      SET OF 1. Help with personal care, (e.g. getting in and out of bed, dressing, bathing and showering)
      2. Help with domestic tasks (e.g. cleaning, ironing, cooking)
      3. Meals-on-wheels (i.e. ready made meals provided by a municipality or a private provider)
      4. Help with other activities (e.g. filling a drug dispenser)
      96. None of the above

      CHECK: (NOT((count(HC127_AtHomeCare) > 1 AND ((a96 IN (HC127_AtHomeCare)))) [You cannot select '96' together with any other answer. Please change your answer.;]
         IF ((a1 IN (HC127_AtHomeCare))
         ⊟
            HC033_WksNursCare (WEEKS RECEIVED PROFESSIONAL NURSING CARE)
               During the last twelve months, how many weeks did you receive professional or paid help with personal care in
               your own home?
               Count 4 weeks for each full month; count 1 for part of one week. Weeks received professional nursing care.
               NUMBER [1..52]

            HC034_HrsNursCare (HOURS RECEIVED PROFESSIONAL NURSING CARE)
               On average, how many hours per week did you receive professional or paid help with personal care at home?
               Round up to full hours. Hours received professional nursing care.
               NUMBER [1..168]

         ENDIF
         IF ((a2 IN (HC127_AtHomeCare))
         ⊟
            HC035_WksDomHelp (WEEKS OF HELP WITH DOMESTIC TASKS)
               During the last twelve months, how many weeks did you receive professional or paid help for domestic tasks at
               home (because you could not perform them yourself due to health problems)?
               Count 4 weeks for each full month; count 1 for part of one week. Weeks received professional domestic help.
               NUMBER [1..52]

            HC036_HrsDomHelp (WEEKLY HOURS OF HELP WITH DOMESTIC TASKS)
               On average, how many hours per week did you receive such professional or paid help?
               Round up to full hours. Hours received paid domestic help.
               NUMBER [1..168]

         ENDIF
         IF ((a3 IN (HC127_AtHomeCare))
         ⊟
            HC037_WksMoW (WEEKS RECEIVED MEALS-ON-WHEELS)
               During the last twelve months, how many weeks did you receive meals-on-wheels, because you could not prepare
               meals due to health problems?
               Count 4 weeks for each full month. Weeks received meals-on-wheels.
               NUMBER [1..52]

         ENDIF
      HC029_NursHome (IN A NURSING HOME)
      During the last twelve months, that is since ^FLLastYearMonth;, have you been in a nursing home/residential care facility
      overnight?
      When a respondent definitely moved to a nursing home less than 12 months ago, answer 1 (Yes, temporarily).
      1. Yes, temporarily
      3. Yes, permanently
      5. No

      CHECK: (NOT(HC029_NursHome = a3)) [At the beginning of this interview you entered that the R's home is not a nursing
      home. Now you have entered that the R lives permanently in a nursing home. Please enter a remark to explain;]
         IF ((HC029_NursHome = a1 OR (HC029_NursHome = a3))

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 72 ---

HC751_Certifiednurse (AT LEAST A NURSE)
         Was there at least one (certified) nurse in the assistance or supervision staff?
         1. Yes
         5. No

      ENDIF
      IF (HC029_NursHome = a1)
      ⊟
         HC031_WksNursHome (WEEKS STAYED IN A NURSING HOME)
            During the last 12 months, how many weeks altogether did you stay in a nursing home?
            Count 4 weeks for each full month; count 1 for part of one week
            NUMBER [1..52]

      ENDIF
      IF ((HC029_NursHome = a1 OR (HC029_NursHome = a3))
      ⊟
         HC696_OOP_NursingHomeYesNo (PAYED ANYTHING OUT OF POCKET NURSING HOME)
            Did you pay anything yourself for nursing home stays in the last twelve months?
            1. Yes
            5. No

            IF (HC696_OOP_NursingHomeYesNo = a1)
            ⊟
               HC097_OOP_NursingHomeAmount (HOW MUCH PAYED OUT OF POCKET NURSING HOME)
                  How much did you pay overall for your nursing home stays in the last twelve months?
                  Enter an amount in ^FLCurr;
                  NUMBER [0..100000000000000000]

                  IF (HC097_OOP_NursingHomeAmount = NONRESPONSE)
                  ⊟
                     |[Unfolding Bracket Sequence]
                     ENDIF
            ENDIF
      ENDIF
   ENDIF
HC063_IntCheck (WHO ANSWERED THE QUESTIONS IN HC)

   CHECK:
   Who answered the questions in this section?
   1. Respondent only
   2. Respondent and proxy
   3. Proxy only

ENDIF
IF (NOT(MN029_linkage = 0))
⊟
   IF (((MN029_linkage = 1 OR (MN029_linkage = 2) OR (MN029_linkage = 3))
   ⊟
      IF ((MN029_linkage = 1 OR (MN029_linkage = 3))
      ⊟
         LI004_Intro (LINKING INTRO)
            We are now changing the topic. The researchers of this study are interested in analyzing the working lives of
            people in [Germany]. They could do important research if your interview responses could be linked with data
            collected by the [German Pension Fund]. We would like to link your interview responses with data of the [German
            Pension Fund]. Giving us your consent is completely voluntary. Please take a few minutes to read this form.
            Take the 2 consent forms and hand out 1 to the respondent. Answer all questions of the respondent.
            Start of a Non-proxy section. No proxy allowed. If the respondent is not present or not capable to give consent on
            her/his own, press CTRL-K at each question.
            1. Consent form for linkage has been provided

         LI001_Number (ID RECORD LINKAGE)

            Take the other consent form and enter the 6 digit key number (on the top right of the form) into CAPI.
            STRING

         LI002_Number_Check (ID RECORD LINKAGE AGAIN)

            REPEAT THE NUMBER.
            STRING

            IF ((LI001_Number = RESPONSE AND (LI002_Number_Check = RESPONSE))
            ⊟
               |CHECK: (LI001_Number = LI002_Number_Check) [values should be equal;]
            ENDIF
         LI003_Consent (LINKAGE COMPLETED)
            Do you consent to the linkage with data of the [German Pension Fund] as described in the form?
            If R consented, ask R to complete the form. Assist if necessary. Then insert the completed consent form in the
            envelope [addressed DRV] and bring it to the mail box later. If R is still unsure, R may complete the form later and
            send it back himself/herself. If R refused, cross the form and send it back anyway. The blank form always remains
            with R.
            1. Yes. R consented.
            2. R is still unsure.
            5. No. R refused.

      ELSE
      ⊟
         IF (MN029_linkage = 2)
         ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 73 ---

LI006_consent (LINKAGE CONSENT QUESTION)
            Intro and consent question (EACH COUNTRY FILLS IN COUNTRY SPECIFIC CONSENT INTRO AND CONSENT
            QUESTION)
            Hand out the linkage related consent information to respondent. Answer all questions of the respondent.
            Start of a Non-proxy section. No proxy allowed. If the respondent is not present or not capable to give
            consent on her/his own, press CTRL-K at each question.
            1. Consent given and consent information left with respondent
            5. No consent

         ENDIF
      ENDIF
      IF (((MN029_linkage = 2 AND (LI006_consent = a1) OR ((MN029_linkage = 3 AND (LI003_Consent = a1)))
      ⊟

         LI007_SSN (SOCIAL SECURITY NUMBER)
         What is your Social Security Number?
         Enter the 10 digit SSN without spaces or dashes into the CAPI. If SSN is not accepted, set a remark by pressing
         Ctrl+M. Then press Ctrl+R to continue with the interview.
         STRING

            IF ((MN029_linkage = 2 AND (LI007_SSN = RESPONSE))
            ⊟
               |CHECK: (checked = 1) [SSN is incorrect please try again!;]
            ELSE
            ⊟
                  IF ((MN029_linkage = 3 AND (LI003_Consent = a1))
                  ⊟
                     LI008_SSN_Check (SOCIAL SECURITY NUMBER)
                        Please repeat your Social Security Number.
                        Enter the 10 digit SSN without spaces or dashes into the CAPI. Add a remark by pressing Ctrl+M for
                        any problem.
                        STRING

                           IF ((LI007_SSN = RESPONSE AND (LI008_SSN_Check = RESPONSE))
                           ⊟
                              |CHECK: (LI007_SSN = LI008_SSN_Check) [values should be equal;]
                           ENDIF
                  ENDIF
            ENDIF
      ENDIF
   ENDIF
LI809_EndNonProxy (WHO ANSWERED THE QUESTIONS IN L1)

CHECK: Who answered the questions in this section?
1. Respondent
2. Section not answered (proxy interview)

      ENDIF
ENDIF
IF (((EP IN (Test) OR ((ALL IN (Test)))
⊟

      IF (MN024_NursingHome = a1)
      ⊟
         EP001_Intro (INTRODUCTION EMPLOYMENT AND PENSIONS)
            Now I am going to ask you some questions about your current employment situation.
            1. Continue

      EP005_CurrentJobSit (CURRENT JOB SITUATION)
         Please look at card 21. In general, which of the following best describes your current employment situation?
         Code only one
         Only if R in doubt then refer to the following:
         1. Retired (retired from own work, including semi-retired, partially retired, early retired, pre-retired). Retired refers to
         retired from own work only. Recipients of survivor pensions who do not receive pensions from own work should not be
         coded as retired. If they do not fit in categories 2 through 5, they should go into other.
         1. Retired
         2. Employed or self-employed (including working for family business)
         3. Unemployed
         4. Permanently sick or disabled
         5. Homemaker
         97. Other

            IF ((EP005_CurrentJobSit = a1 AND (MN041_retireinfo = 1))
            ⊟
               EP329_RetYear (RETIREMENT YEAR)
                  In which year did you retire?
                  NUMBER [1900..2024]

                     IF (EP329_RetYear = RESPONSE)
                     ⊟
                        |CHECK: (NOT(EP329_RetYear < MN002_Person[1].Year16)) [Retirement year lies before 16th birthday. If
                        year is correct, please press "suppress" and enter a remark to explain;]
                     ENDIF
               EP328_RetMonth (RETIREMENT MONTH)
                  Do you remember in what month that was?
                  1. January
                  2. February
                  3. March
                  4. April
                  5. May
                  6. June
                  7. July

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 74 ---

8. August
         9. September
         10. October
         11. November
         12. December

         EP064_ResForRet (MAIN REASON FOR EARLY RETIREMENT)
           Please look at card 22.
           For which reasons did you retire?
           Code all that apply.;
           SET OF 1. Became eligible for public pension
           2. Became eligible for private occupational pension
           3. Became eligible for a private pension
           4. Was offered an early retirement option/window with special incentives or bonus
           5. Made redundant (for example pre-retirement)
           6. Own ill health
           7. Ill health of relative or friend
           8. To retire at same time as spouse or partner
           9. To spend more time with family
           10. To enjoy life

ENDIF
IF (EP005_CurrentJobSit = a3)
 ⊟
      EP337_LookingForJob (LOOKING FOR JOB)
        Are you currently looking for a job?
        1. Yes
        5. No

      EP067_HowUnempl (HOW BECAME UNEMPLOYED)
        Would you tell us how you became unemployed? Was it
        Read out.;
        For seasonal workers code 5
        1. Because your place of work or office closed
        2. Because you resigned
        3. Because you were laid off
        4. By mutual agreement between you and your employer
        5. Because a temporary job had been completed
        6. Because you moved to another town
        97. Other reason

ENDIF
IF (EP005_CurrentJobSit <> a2)
 ⊟
      EP002_PaidWork (DID ANY PAID WORK)
        [We are interested in your work experiences since our last interview.] Did you do any paid work[since our last
        interview in/ during the last four weeks], either as an employee or self-employed, even if this was only for a few
        hours?
        1. Yes
        5. No

ENDIF
IF (MN101_Longitudinal = 0)
 ⊟
        IF ((((EP005_CurrentJobSit = 4 OR (EP005_CurrentJobSit = 5) OR (EP005_CurrentJobSit = 97) AND
        (EP002_PaidWork = a5))
         ⊟
            EP006_EverWorked (EVER DONE PAID WORK)
              Have you ever done any paid work?
              1. Yes
              5. No

        ENDIF
ENDIF
IF (MN101_Longitudinal = 1)
 ⊟
        IF ((EP005_CurrentJobSit = a2 OR (EP002_PaidWork = a1))
         ⊟
            EP125_ContWork (CONTINUOUSLY WORKING)
              I'd like to know about all of the work for pay that you may have done since ^FLLastInterviewMonthYear;
              through the present. During that time, have you been working continuously?
              Vacation period should not be counted as interruptions.
              1. Yes
              5. No

        ENDIF
        IF (EP125_ContWork = a1)
         ⊟
            EP141_ChangeInJob (CHANGE IN JOB)
              Please look at card 23. Even though you have been working continuously since
              ^FLLastInterviewMonthYear;, have you experienced any of the changes listed on this card?
              Code all that apply.;
              SET OF 1. A change in type of employment (for instance from dependent employment to self-employment)
              2. A change in employer
              3. A promotion
              4. A change in job location
              5. A change in contract length (from long term to short term or viceversa)
              96. None of the above

            CHECK: (NOT((count(EP141_ChangeInJob) > 1 AND ((96 IN (EP141_ChangeInJob)))) [You cannot select '96'

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 75 ---

|together with any other answer. Please change your answer.;]
ENDIF
IF (EP125_ContWork = a5)
 ⊟
     EP127_PeriodFromMonth (PERIOD FROM MONTH)
        From what month and year have you been[working/ unemployed]?

        MONTH:
        YEAR:
        1. January
        2. February
        3. March
        4. April
        5. May
        6. June
        7. July
        8. August
        9. September
        10. October
        11. November
        12. December

     EP128_PeriodFromYear (PERIOD FROM YEAR)
        From what month and year have you been[working/ unemployed]?

        MONTH ^EP127_PeriodFromMonth;
        YEAR
        1. 2005 or earlier
        2. 2006
        3. 2007
        4. 2008
        5. 2009
        6. 2010
        7. 2011
        8. 2012
        9. 2013
        10. 2014
        11. 2015
        12. 2016
        13. 2017
        14. 2018
        15. 2019
        16. 2020
        17. 2021
        18. 2022
        19. 2023
        20. 2024

     EP129_PeriodToMonth (PERIOD TO MONTH)
        To what month and year have you been[working/ unemployed]?

        MONTH:
        YEAR:
        If spell still ongoing type 13. Today
        1. January
        2. February
        3. March
        4. April
        5. May
        6. June
        7. July
        8. August
        9. September
        10. October
        11. November
        12. December
        13. Today

        IF (EP129_PeriodToMonth <> a13)
        ⊟
             EP130_PeriodToYear (PERIOD TO YEAR)
                 To what month and year have you been[working/ unemployed]?


                 MONTH: ^EP129_PeriodToMonth;

                 YEAR:
                 To year
                 1. 2005 or earlier
                 2. 2006
                 3. 2007
                 4. 2008
                 5. 2009
                 6. 2010
                 7. 2011
                 8. 2012
                 9. 2013
                 10. 2014
                 11. 2015
                 12. 2016
                 13. 2017
                 14. 2018

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 76 ---

15. 2019
            16. 2020
            17. 2021
            18. 2022
            19. 2023
            20. 2024

   ENDIF
EP133_PeriodOtherEp (OTHER PERIODS)
  Were there other times since ^FLLastInterviewMonthYear; when you have been[working for pay/
  unemployed]?
  1. Yes
  5. No

[1]    LOOP cnt := 2 TO 20
   ⊟
        IF (PeriodOtherEpisodes[cnt - 1].EP133_PeriodOtherEp = a1)
        ⊟
             EP127_PeriodFromMonth (PERIOD FROM MONTH)
               From what month and year have you been[working/ unemployed]?

               MONTH:
               YEAR:
               1. January
               2. February
               3. March
               4. April
               5. May
               6. June
               7. July
               8. August
               9. September
               10. October
               11. November
               12. December

             EP128_PeriodFromYear (PERIOD FROM YEAR)
               From what month and year have you been[working/ unemployed]?

               MONTH ^EP127_PeriodFromMonth;
               YEAR
               1. 2005 or earlier
               2. 2006
               3. 2007
               4. 2008
               5. 2009
               6. 2010
               7. 2011
               8. 2012
               9. 2013
               10. 2014
               11. 2015
               12. 2016
               13. 2017
               14. 2018
               15. 2019
               16. 2020
               17. 2021
               18. 2022
               19. 2023
               20. 2024

             EP129_PeriodToMonth (PERIOD TO MONTH)
               To what month and year have you been[working/ unemployed]?

               MONTH:
               YEAR:
               If spell still ongoing type 13. Today
               1. January
               2. February
               3. March
               4. April
               5. May
               6. June
               7. July
               8. August
               9. September
               10. October
               11. November
               12. December
               13. Today

               IF (EP129_PeriodToMonth <> a13)
               ⊟
                    EP130_PeriodToYear (PERIOD TO YEAR)
                      To what month and year have you been[working/ unemployed]?


                      MONTH: ^EP129_PeriodToMonth;

                      YEAR:
                      To year

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 77 ---

1. 2005 or earlier
                                        2. 2006
                                        3. 2007
                                        4. 2008
                                        5. 2009
                                        6. 2010
                                        7. 2011
                                        8. 2012
                                        9. 2013
                                        10. 2014
                                        11. 2015
                                        12. 2016
                                        13. 2017
                                        14. 2018
                                        15. 2019
                                        16. 2020
                                        17. 2021
                                        18. 2022
                                        19. 2023
                                        20. 2024

                                        ENDIF
                                    EP133_PeriodOtherEp (OTHER PERIODS)
                                      Were there other times since ^FLLastInterviewMonthYear; when you have been[working for
                                      pay/ unemployed]?
                                      1. Yes
                                      5. No

                                    [cnt]
                                    ENDIF
                                ENDLOOP
                            ENDIF
                ENDIF
                IF ((((MN101_Longitudinal = 0 AND (EP006_EverWorked = a1) AND (EP005_CurrentJobSit = a5) OR
            ((((MN101_Longitudinal = 1 AND (EP005_CurrentJobSit = a5) AND (EP002_PaidWork = a1) AND (EP335_Today = a5)))
            ⊟
                    EP069_ResStopWork (REASON STOP WORKING)
                      You said you are currently a homemaker, but you have done paid work in the past. Why did you stop working?
                      Read out.; Code all that apply.;
                      1. Because of health problems
                      2. It was too tiring
                      3. It was too expensive to hire someone to look after home or family
                      4. Because you wanted to take care of children or grandchildren
                      5. Because you were laid off, or your place of work or office closed
                      6. Because family income was sufficient
                      7. To care for an old or sick family member
                      97. Other

            ENDIF
            IF (MN101_Longitudinal = 1)
            ⊟
                    IF (((EP005_CurrentJobSit <> a3 AND ((EP125_ContWork = a5 OR ((EP005_CurrentJobSit <> a2 AND
                (EP002_PaidWork = a5))) AND (MN808_AgeRespondent <= 75))
                ⊟
                        EP325_UnEmpl (UNEMPLOYED)
                          Were there any times since ^FLLastInterviewMonthYear;, when you were unemployed?
                          1. Yes
                          5. No

                ENDIF
                IF (EP005_CurrentJobSit = a3)
                ⊟
                        EP632_Intro (INTRODUCTION WHEN UNEMPLOYED)
                          Now I'd like to know about the times since our last interview through the present in which you were
                          unemployed.
                          1. Continue

                ENDIF
                IF ((EP325_UnEmpl = a1 OR (EP005_CurrentJobSit = a3))
                ⊟
                        EP633_Intro (INTRODUCTION DATES UNEMPLOYED)
                          When were you unemployed? Please give me all of your start and stop dates.
                          1. Continue

                        EP127_PeriodFromMonth (PERIOD FROM MONTH)
                          From what month and year have you been[working/ unemployed]?

                          MONTH:
                          YEAR:
                          1. January
                          2. February
                          3. March
                          4. April
                          5. May
                          6. June
                          7. July
                          8. August
                          9. September
                          10. October
                          11. November
                          12. December

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 78 ---

EP128_PeriodFromYear (PERIOD FROM YEAR)
  From what month and **year** have you been*[working/ unemployed]*?

  MONTH ^EP127_PeriodFromMonth;
  **YEAR**
  1. 2005 or earlier
  2. 2006
  3. 2007
  4. 2008
  5. 2009
  6. 2010
  7. 2011
  8. 2012
  9. 2013
  10. 2014
  11. 2015
  12. 2016
  13. 2017
  14. 2018
  15. 2019
  16. 2020
  17. 2021
  18. 2022
  19. 2023
  20. 2024

**EP129_PeriodToMonth** (PERIOD TO MONTH)
  To what **month** and year have you been*[working/ unemployed]*?

  **MONTH**:
  YEAR:
  If spell still ongoing type 13. Today
  1. January
  2. February
  3. March
  4. April
  5. May
  6. June
  7. July
  8. August
  9. September
  10. October
  11. November
  12. December
  13. Today

  *IF (EP129_PeriodToMonth <> a13)*
  ⊟
       **EP130_PeriodToYear** (PERIOD TO YEAR)
            To what month and **year** have you been*[working/ unemployed]*?

            MONTH: ^EP129_PeriodToMonth;

            **YEAR**:
            To year
            1. 2005 or earlier
            2. 2006
            3. 2007
            4. 2008
            5. 2009
            6. 2010
            7. 2011
            8. 2012
            9. 2013
            10. 2014
            11. 2015
            12. 2016
            13. 2017
            14. 2018
            15. 2019
            16. 2020
            17. 2021
            18. 2022
            19. 2023
            20. 2024

  *ENDIF*
**EP133_PeriodOtherEp** (OTHER PERIODS)
  Were there other times since ^FLLastInterviewMonthYear; when you have been*[working for pay/ unemployed]*?
  1. Yes
  5. No

[21]   *LOOP cnt := 22 TO 40*
  ⊟
          *IF (PeriodOtherEpisodes[cnt - 1].EP133_PeriodOtherEp = a1)*
          ⊟
               **EP127_PeriodFromMonth** (PERIOD FROM MONTH)
                    From what **month** and year have you been*[working/ unemployed]*?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 79 ---

**MONTH**:
   YEAR:
   1. January
   2. February
   3. March
   4. April
   5. May
   6. June
   7. July
   8. August
   9. September
   10. October
   11. November
   12. December

**EP128_PeriodFromYear** (PERIOD FROM YEAR)
   From what month and **year** have you been*[working/ unemployed]*?

   MONTH ^EP127_PeriodFromMonth;
   **YEAR**
   1. 2005 or earlier
   2. 2006
   3. 2007
   4. 2008
   5. 2009
   6. 2010
   7. 2011
   8. 2012
   9. 2013
   10. 2014
   11. 2015
   12. 2016
   13. 2017
   14. 2018
   15. 2019
   16. 2020
   17. 2021
   18. 2022
   19. 2023
   20. 2024

**EP129_PeriodToMonth** (PERIOD TO MONTH)
   To what **month** and year have you been*[working/ unemployed]*?

   **MONTH**:
   YEAR:
   If spell still ongoing type 13. Today
   1. January
   2. February
   3. March
   4. April
   5. May
   6. June
   7. July
   8. August
   9. September
   10. October
   11. November
   12. December
   13. Today

   IF *(EP129_PeriodToMonth <> a13)*
   ⊟
      **EP130_PeriodToYear** (PERIOD TO YEAR)
         To what month and **year** have you been*[working/ unemployed]*?


         MONTH: ^EP129_PeriodToMonth;

         **YEAR**:
         To year
         1. 2005 or earlier
         2. 2006
         3. 2007
         4. 2008
         5. 2009
         6. 2010
         7. 2011
         8. 2012
         9. 2013
         10. 2014
         11. 2015
         12. 2016
         13. 2017
         14. 2018
         15. 2019
         16. 2020
         17. 2021
         18. 2022
         19. 2023
         20. 2024

   *ENDIF*

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 80 ---

EP133_PeriodOtherEp (OTHER PERIODS)
                        Were there other times since ^FLLastInterviewMonthYear; when you have been[working for
                        pay/ unemployed]?
                        1. Yes
                        5. No

                        [cnt]
                    ENDIF
                ENDLOOP
            ENDIF
        ENDIF
        IF (((EP005_CurrentJobSit = a2 OR ((MN101_Longitudinal = 0 AND (EP002_PaidWork = a1)) OR ((MN101_Longitudinal
= 1 AND (EP335_Today = a1)))
        ⊟
            EP008_Intro1 (INTRODUCTION CURRENT JOB)
            The following questions are about your current main job.
            Including seasonal job. The main job is the job the respondent is working most hours for. If same hours then
            choose the one the respondent gets more money from.
            1. Continue

            EP009_EmployeeOrSelf (EMPLOYEE OR SELF-EMPLOYED)
              In this job are you a private-sector employee, a public sector employee or self-employed?
              1. Private sector employee
              2. Public sector employee
              3. Self-employed

              IF (((MN101_Longitudinal = 0 OR (NOT((a96 IN (EP141_ChangeInJob))) OR (EP125_ContWork = a5))
              ⊟
                    EP010_CurJobYear (START OF CURRENT JOB (YEAR))
                    In which year did you start this job?
                    NUMBER [1940..2024]

                    IF (EP010_CurJobYear = RESPONSE)
                    ⊟
                        CHECK: (NOT( YEAR(SYSDATE()) - EP010_CurJobYear10 > MN808_AgeRespondent)) [Year should be
                        at least 10 years after year of birth. If year is correct, please press "suppress" and enter a remark to
                        explain;]
                    ENDIF
                EP616_NTofJob (NAME OR TITLE OF JOB)
                What is this job called? Please give the exact name or title.
                STRING

                IF (NOT(EP616_NTofJob = Refusal))
                ⊟
                        EP616c_NTofJobCode (JOBCODER - NAME OR TITLE OF JOB)
                          I will now search for your job title among official jobs titles in our database.
                          Re-type the job title and select the best match from the drop-down list. Please, check for spelling
                          mistakes. If you navigate or scroll down, you will find more job titles.
                          If you don't find the job title, ask the R to think of a different name for the job or to give a broader or
                          a more specific job description.
                          If you cannot find any good match at all, type 991.
                          STRING

                        JOBCODER: InDataOccupationsA
                          IF ((NOT(EP616c_NTofJobCode = Empty) AND (NOT(EP616c_NTofJobCode = 991)))
                          ⊟
                                EP616d_NTofJobCode (JOBCODER - NEXT)

                                    Please verify that you selected the correct job title:
                                    ^EP616c_NTofJobCode;
                                    If this is not the correct job title, go back and select the best match from the drop-down list.
                                    1. Confirm and continue

                            ENDIF
                    ENDIF
                EP018_WhichIndustry (WHICH INDUSTRY ACTIVE)
                Please look at card 24. What kind of business, industry or services do you work in?
                1. Agriculture, hunting, forestry, fishing
                2. Mining and quarrying
                3. Manufacturing
                4. Electricity, gas and water supply
                5. Construction
                6. Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods
                7. Hotels and restaurants
                8. Transport, storage and communication
                9. Financial intermediation
                10. Real estate, renting and business activities
                11. Public administration and defence; compulsory social security
                12. Education
                13. Health and social work
                14. Other community, social and personal service activities

                IF (EP009_EmployeeOrSelf = 3)
                ⊟
                        EP024_NrOfEmployees (NUMBER OF EMPLOYEES)
                          How many employees, if any, do you have in this job?
                          Excluding respondent; only count people who work for or under the supervision of the respondent
                          Read out.;
                          0. None
                          1. 1 to 5
                          2. 6 to 15

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 81 ---

3. 16 to 24
                        4. 25 to 199
                        5. 200 to 499
                        6. 500 or more

                *ENDIF*
                *IF ((EP009_EmployeeOrSelf = a1 OR (EP009_EmployeeOrSelf = 2))*
                ⊟
                        **EP811_TermJob** (TERM OF JOB)
                          In this job, do you have a fixed-term or a permanent contract?
                          If asked, please explain that fixed-term contract has a pre-determined termination date
                          1. Fixed-term
                          2. Permanent
                          3. No contract (spontaneous only)

                *ENDIF*
            *ENDIF*
        **EP013_TotWorkedHours** (TOTAL HOURS WORKED PER WEEK)
          Including any paid or unpaid overtime, but not counting meal breaks, how many hours a week do you usually work
          in this job?
          This refers to the 'usual' working week. A seasonal worker working 40 hours a week for three months a year,
          should answer 40.
          NUMBER [0..168]

          *IF (EP013_TotWorkedHours = RESPONSE)*
          ⊟
            **CHECK**: (EP013_TotWorkedHours < 71) *[Please check, number of hours seems too high. If the number of
            hours is correct, please press "suppress" and enter a remark to explain.;]*
          *ENDIF*
    *ENDIF*
    *IF (EP005_CurrentJobSit = a2)*
    ⊟
        *IF (MN101_Longitudinal = 1)*
        ⊟
            **EP025_Intro** (INTRODUCTION WORK SATISFACTION)
              Please look at card 25.
              Regarding your present job we would like to know whether you strongly agree, agree, disagree or strongly
              disagree with the following statements.
              Start of a **Non-proxy** section. No proxy allowed. If the respondent is not capable of answering any of these
              questions on her/his own, press CTRL-K at each question.
              1. Continue

            **EP026_SatJob** (SATISFIED WITH JOB)
              All things considered I am satisfied with my job. Would you say you strongly agree, agree, disagree or
              strongly disagree?
              Show card 25
              1. Strongly agree
              2. Agree
              3. Disagree
              4. Strongly disagree

            **EP027_JobPhDem** (JOB PHYSICALLY DEMANDING)
              My job is physically demanding. Would you say you strongly agree, agree, disagree or strongly disagree?
              Show card 25
              1. Strongly agree
              2. Agree
              3. Disagree
              4. Strongly disagree

            **EP028_TimePress** (TIME PRESSURE DUE TO A HEAVY WORKLOAD)
              I am under constant time pressure due to a heavy workload. (Would you say you strongly agree, agree,
              disagree or strongly disagree?)
              Show card 25
              1. Strongly agree
              2. Agree
              3. Disagree
              4. Strongly disagree

            **EP029_LitFreeWork** (LITTLE FREEDOM TO DECIDE HOW I DO MY WORK)
              I have very little freedom to decide how I do my work. (Would you say you strongly agree, agree, disagree
              or strongly disagree?)
              Show card 25
              1. Strongly agree
              2. Agree
              3. Disagree
              4. Strongly disagree

            **EP030_NewSkill** (I HAVE AN OPPORTUNITY TO DEVELOP NEW SKILLS)
              I have an opportunity to develop new skills. (Would you say you strongly agree, agree, disagree or strongly
              disagree?)
              Show card 25
              1. Strongly agree
              2. Agree
              3. Disagree
              4. Strongly disagree

            **EP031_SuppDiffSit** (SUPPORT IN DIFFICULT SITUATIONS)
              I receive adequate support in difficult situations. (Would you say you strongly agree, agree, disagree or
              strongly disagree?)
              Show card 25
              1. Strongly agree
              2. Agree

--- page 82 ---

3. Disagree
         4. Strongly disagree

         EP032_RecognWork (RECEIVE THE RECOGNITION DESERVING FOR MY WORK)
           I receive the recognition I deserve for my work. (Would you say you strongly agree, agree, disagree or
           strongly disagree?)
           Show card 25
           1. Strongly agree
           2. Agree
           3. Disagree
           4. Strongly disagree

         EP033_SalAdequate (SALARY OR EARNINGS ARE ADEQUATE)
           Considering all my efforts and achievements, my[salary is/ earnings are] adequate. (Would you say you
           strongly agree, agree, disagree or strongly disagree?)
           Show card 25. In case of doubt explain: we mean adequate for the work done.
           1. Strongly agree
           2. Agree
           3. Disagree
           4. Strongly disagree

         EP034_JobPromPoor (PROSPECTS FOR JOB ADVANCEMENT ARE POOR)
           My[job promotion prospects/ prospects for job advancement] are poor. (Would you say you strongly agree,
           agree, disagree or strongly disagree?)
           Show card 25
           1. Strongly agree
           2. Agree
           3. Disagree
           4. Strongly disagree

         EP035_JobSecPoor (JOB SECURITY IS POOR)
           My job security is poor. (Would you say you strongly agree, agree, disagree or strongly disagree?)
           Show card 25
           1. Strongly agree
           2. Agree
           3. Disagree
           4. Strongly disagree

         ENDIF
      ENDIF
      IF (((EP005_CurrentJobSit = a2 OR ((MN101_Longitudinal = 0 AND (EP002_PaidWork = a1)) OR ((MN101_Longitudinal
= 1 AND (EP335_Today = a1)))
      ⊟
         IF (EP005_CurrentJobSit = a2)
         ⊟
            EP036_LookForRetirement (LOOK FOR EARLY RETIREMENT)
              Thinking about your present job, would you like to retire as early as you can from this job?
              1. Yes
              5. No

            EP037_AfraidHRet (AFRAID HEALTH LIMITS ABILITY TO WORK BEFORE REGULAR RETIREMENT)
              Are you afraid that your health will limit your ability to work in this job before regular retirement?
              1. Yes
              5. No

            EP007_MoreThanOneJob (CURRENTLY MORE THAN ONE JOB)
              So far we have talked about your main job. Do you currently have a second job besides your main job?
              Please consider only paid jobs
              1. Yes
              5. No

         ENDIF
      ENDIF
      IF ((MN101_Longitudinal = 0 AND (((EP006_EverWorked = a1 OR (EP005_CurrentJobSit = a1) OR (EP005_CurrentJobSit
= a3)))
      ⊟
         EP048_IntroPastJob (INTRODUCTION PAST JOB)
           We are now going to talk about the last job you had[before you retired/ before you became unemployed].
           1. Continue

         EP050_YrLastJobEnd (YEAR LAST JOB END)
           In which year did your last job end?
           NUMBER [1900..2024]

           IF (EP050_YrLastJobEnd = RESPONSE)
           ⊟
              CHECK: ( YEAR(SYSDATE()) - EP050_YrLastJobEnd10 < MN808_AgeRespondent) [Year should be at least 10
              years after year of birth. If year is correct, please press "suppress" and enter a remark to explain;]
           ENDIF
         EP649_YrsInLastJob (YEARS WORKING IN LAST JOB)
           How many years did you work in your last job?
           If more than one job, the question should refer to the one considered as main job by respondent. Include periods
           of unpaid leave. If the job spell lasted between 6 months and 1 year, count it as 1 year. If the job spell lasted less
           than 6 months, count it as 0.
           NUMBER [0..99]

           IF (EP649_YrsInLastJob = RESPONSE)
           ⊟
              CHECK: (EP649_YrsInLastJob < MN808_AgeRespondent) [Number should be less than or equal to
              respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]
           ENDIF
         EP051_EmployeeORSelf (EMPLOYEE OR A SELF EMPLOYED IN LAST JOB)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 83 ---

In this job were you a private sector employee, a public sector employee or self-employed?
            1. Private sector employee
            2. Public sector employee
            3. Self-employed

            EP152_NTofJob (NAME OR TITLE OF JOB)
            What was this job called? Please give the exact name or title.
            STRING

             IF (NOT(EP152_NTofJob = Refusal))
            ⊟
                  EP152c_NtofJobCode (JOBCODER - NAME OR TITLE OF JOB)
                  I will now search for your job title among official jobs titles in our database.
                  Re-type the job title and select the best match from the drop-down list. Please, check for spelling mistakes.
                  If you navigate or scroll down, you will find more job titles.
                  If you don't find the job title, ask the R to think of a different name for the job or to give a broader or a
                  more specific job description.
                  If you cannot find any good match at all, type 991.
                  STRING

                  JOBCODER: InDataOccupationsB
                     IF ((NOT(EP152c_NtofJobCode = Empty) AND (NOT(EP152c_NtofJobCode = 991)))
                     ⊟
                           EP152d_NtofJobCode (JOBCODER - NEXT)

                              Please verify that you selected the correct job title:
                              ^EP152c_NTofJobCode;
                              If this is not the correct job title, go back and select the best match one from the drop-down list.
                              1. Confirm and continue

                     ENDIF
             ENDIF
            EP054_WhichIndustry (WHICH INDUSTRY ACTIVE)
            Please look at card 24. What kind of business, industry or services did you work in?
            1. Agriculture, hunting, forestry, fishing
            2. Mining and quarrying
            3. Manufacturing
            4. Electricity, gas and water supply
            5. Construction
            6. Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods
            7. Hotels and restaurants
            8. Transport, storage and communication
            9. Financial intermediation
            10. Real estate, renting and business activities
            11. Public administration and defence; compulsory social security
            12. Education
            13. Health and social work
            14. Other community, social and personal service activities

             IF (EP051_EmployeeORSelf = 3)
            ⊟
                  EP061_NrOfEmployees (NUMBER OF EMPLOYEES)
                  How many employees, if any, did you have?
                  Read answers out
                  0. None
                  1. 1 to 5
                  2. 6 to 15
                  3. 16 to 24
                  4. 25 to 199
                  5. 200 to 499
                  6. 500 or more

             ENDIF
         ENDIF
   ENDIF
EP203_IntroEarnings (INTRO INDIVIDUAL INCOME)
  We would now like to know more about your earnings and income during the last year, that is in ^FLLastYear;.
  1. Continue

EP204_AnyEarnEmpl (ANY EARNINGS FROM EMPLOYMENT LAST YEAR)
  Have you had any wages, salaries or other earnings from dependent employment in ^FLLastYear;?
  1. Yes
  5. No

   IF (EP204_AnyEarnEmpl = a1)
   ⊟
      EP205_EarningsEmplAT (EARNINGS EMPLOYMENT PER YEAR AFTER TAXES)
      After any taxes and contributions, what was your approximate annual income from employment in the year
      ^FLLastYear;? Please include any additional or extra or lump sum payment, such as bonuses, 13th month, Christmas or
      Summer pays.
      Amount in ^FLCurr;
      NUMBER [0..100000000000000000]

         IF (EP205_EarningsEmplAT = NONRESPONSE)
         ⊟
            |[Unfolding Bracket Sequence]
         ENDIF
   ENDIF
EP206_AnyIncSelfEmpl (INCOME FROM SELF-EMPLOYMENT LAST YEAR)
  Have you had any income at all from self-employment or work for a family business in ^FLLastYear;?
  1. Yes

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 84 ---

5. No

  IF (EP206_AnyIncSelfEmpl = a1)
  ⊟
       EP207_EarningsSelfAT (EARNINGS PER YEAR AFTER TAXES FROM SELF-EMPLOYMENT)
       After any taxes and contributions and after paying for any materials, equipment or goods that you use in your work, what
       was your approximate annual income from self-employment in the year ^FLLastYear;?
       Amount in ^FLCurr;
       NUMBER

       IF (EP207_EarningsSelfAT = NONRESPONSE)
       ⊟
            |[Unfolding Bracket Sequence]
            ENDIF
  ENDIF
EP303_Intro (INTRODUCTION INCOME FROM PUBLIC PENSIONS)
  Now we are going to ask you a set of questions regarding income from different public pensions and benefits. We are interested
  in the amounts, timing of these payments, and finally for how long you have received them.
  1. Continue

EP671_IncomeSources (INCOME FROM PUBLIC PENSIONS IN LAST YEAR)
  Please look at card 26.
  Have you received income from any of these sources in the year ^FLLastYear;?
  Code all that apply.; Main public sickness benefits: they are contribution-based payments received as an earnings replacement
  when an employee is off sick.
  Main public disability insurance pension: if the sickness turns out to be long-standing, and a return to work is not to be
  expected, then the claimant will typically be transferred to a disability insurance pension (e.g. invalidity or incapacity benefit).
  The term 'pension' in the heading of this category is to be meant as 'regular payment', rather than relating to old age.
  Public unemployment benefit or insurance: they are received, for a limited time period, by previous employees, later finding
  themselves unemployed. Eligibility is based on a history of insurance contribution.
  Public long-term care insurance: it includes cash payments meant to provide for long term care needs; receipt does not
  necessarily depend on having previously paid contributions.
  Social assistance: it includes cash or voucher programmes meant to provide a general 'safety net', guaranteeing minimum
  resources to those otherwise lacking resources from either employment or contributory based social security benefits/pensions.
  SET OF 1. Public old age pension
  2. Public old age supplementary pension or public old age second pension
  3. Public early retirement or pre-retirement pension
  4. Main public sickness benefits
  5. Main public disability insurance pension
  6. Secondary public disability insurance pension
  7. Secondary public sickness benefits
  8. Public unemployment benefit or insurance
  9. Main public survivor pension from your spouse or partner
  10. Secondary public survivor pension from your spouse or partner
  11. Public war pension
  12. Public long-term care insurance
  13. Social assistance
  96. None of these

CHECK: (NOT((count(EP671_IncomeSources) > 1 AND ((96 IN (EP671_IncomeSources)))) [You cannot select '96' together with
any other answer. Please change your answer.;]
  LOOP cnt := 1 TO 13
  ⊟
       IF ((cnt IN (EP671_IncomeSources))
       ⊟
            EP078_AvPaymPens (TYPICAL PAYMENT OF PENSIONS)
            After taxes, about how large was a typical payment of [your public old age pension/ your public old age
            supplementary pension or public old age second pension/ your public early retirement or pre-retirement pension/
            your main public sickness benefits/ your main public disability insurance pension/ your secondary public disability
            insurance pension/ your Secondary public sickness benefits\'/ your public unemployment benefit or insurance/
            your main public survivor pension from your spouse or partner/ your secondary public survivor pension from your
            spouse or partner/ your public war pension/ your public long-term care insurance/ your social assistance] in
            ^FLLastYear;?
            Amount in ^FLCurr;
            It is an ordinary typical-regular payment, excluding any extras, such as bonuses, 13th month, lump-sum payments
            etc.
            The time period will be asked in the next question: it could be monthly, quarterly or weekly, for example.
            The R should tell what the typical payment was for such a period during the year indicated in the question.
            NUMBER [0...1000000000000000000]

            IF (EP078_AvPaymPens = NONRESPONSE)
            ⊟
                 |[Unfolding Bracket Sequence]
            ENDIF
            EP074_PeriodBenefit (PERIOD OF INCOME SOURCE)
            What period did that payment cover?
            Do not include lump-sum payments. This will be asked later.
            1. One week
            2. Two weeks
            3. Calendar month/4 weeks
            4. Three months/13 weeks
            5. Six months/26 weeks
            6. Full year/12 months/52 weeks
            97. Other (specify)

            IF (EP074_PeriodBenefit = a97)
            ⊟
                 EP075_OthPeriodBenefits (OTHER PERIOD OF RECEIVING BENEFITS)

                 Note other period
                 STRING

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 85 ---

ENDIF
EP208_MonthsRecIncSource (HOW MANY MONTHS RECEIVED INCOME SOURCE)
   For how many months altogether did you receive*[the public old age pension/ the public old age supplementary
   pension or public old age second pension/ the public early retirement or pre-retirement pension/ the main public
   sickness benefits/ the main public disability insurance pension/ the secondary public disability insurance pension/
   the secondary public sickness benefits/ the public unemployment benefit or insurance/ the main public survivor
   pension from your spouse or partner/ the secondary public survivor pension from your spouse or partner/ the
   public war pension/ the public long-term care insurance/ the social assistance]* in ^FLLastYear;?
   Not how many payments were made, but the time-span. Example: the pension was received throughout the whole
   year, the answer is 12. In case the respondent started receiving it in November, the answer is 2.
   NUMBER [1..12]

   *IF (MN101_Longitudinal = 1)*
   ⊟
      EP612_WhenSource_long (BENEFIT BEFORE LAST INTERVIEW)
         Did you first receive *[the public old age pension/ the public old age supplementary pension or public old age
         second pension/ the public early retirement or pre-retirement pension/ the main public sickness benefits/
         the main public disability insurance pension/ the secondary public disability insurance pension/ the
         secondary public sickness benefits/ the public unemployment benefit or insurance/ the main public survivor
         pension from your spouse or partner/ the secondary public survivor pension from your spouse or partner/
         the public war pension/ the public long-term care insurance/ the social assistance]* before our last interview
         in ^FLLastInterviewMonthYear;?
         1. Yes, before last interview
         5. No, after last interview

   *ENDIF*
   *IF ((NOT(MN101_Longitudinal = 1) OR (EP612_WhenSource_long = a5))*
   ⊟
      EP213_YearRecIncSource (YEAR RECEIVED INCOME SOURCE)
         In which year did you first receive your*[public old age pension/ public old age supplementary pension or
         public old age second pension/ public early retirement or pre-retirement pension/ main public sickness
         benefits/ main public disability insurance pension/ secondary public disability insurance pension/ secondary
         public sickness benefits/ public unemployment benefit or insurance/ main public survivor pension from your
         spouse or partner/ secondary public survivor pension from your spouse or partner/ public war pension/
         public long-term care insurance/ social assistance]*?
         In case of benefit received discontinuously during life (e.g., unemployment benefits received for different
         unemployment episodes), refer to the first payment of current stream of benefit, NOT to the first in life.
         NUMBER [1930..2024]

         *IF (EP213_YearRecIncSource = RESPONSE)*
         ⊟
            CHECK: ( YEAR(CURRENTDATE) - EP213_YearRecIncSource <= MN808_AgeRespondent) *[Year should
            be greater than or equal to birthyear. If year is correct, please press "suppress" and enter a remark to
            explain;]*
         *ENDIF*
   *ENDIF*
EP081_LumpSumPenState (LUMP SUM PAYMENT INCOME SOURCE)
   Did you receive any additional, or extra or lump sum (one off) payment from*[your public old age pension/ your
   public old age supplementary pension or public old age second pension/ your public early retirement or pre-
   retirement pension/ your main public sickness benefits/ your main public disability insurance pension/ your
   secondary public disability insurance pension/ your secondary public sickness benefits/ your public unemployment
   benefit or insurance/ your main public survivor pension from your spouse or partner/ your secondary public
   survivor pension from your spouse or partner/ your public war pension/ your public long-term care insurance/ your
   social assistance]* during the year ^FLLastYear;?
   Please make sure that R takes into account all additional/extra/lump-sum payments received (including bonuses,
   13th month, Christmas and Summer pays, if any) to answer this question.
   1. Yes
   5. No

   *IF (EP081_LumpSumPenState = a1)*
   ⊟
      EP082_TotAmountLS (TOTAL AMOUNT OF LUMP SUM PAYMENT FROM INCOME SOURCE)
         After taxes, about how much did you receive overall as additional or extra payments in ^FLLastYear;
         from*[this public old age pension/ this public old age supplementary pension or public old age second
         pension/ this public early retirement or pre-retirement pension/ this main public sickness benefits/ this main
         public disability insurance pension/ this secondary public disability insurance pension/ this secondary public
         sickness benefits/ this public unemployment benefit or insurance/ this main public survivor pension from
         your spouse or partner/ this secondary public survivor pension from your spouse or partner/ this public war
         pension/ this public long-term care insurance/ this social assistance]*?
         Amount in ^FLCurr;
         Include all additional or extra payments
         NUMBER [0..100000000000000000]

         *IF (EP082_TotAmountLS = NONRESPONSE)*
         ⊟
            **[Unfolding Bracket Sequence]**
         *ENDIF*
   *ENDIF*
   [cnt]
   *ENDIF*
*ENDLOOP*
EP624_OccPensInc (HAD OCCUPATIONAL PENSION INCOME SOURCES)
   In addition to public pension benefits, pensions can also be provided through your employer. Have you received income from
   any occupational pension in the year ^FLLastYear;?
   Occupational old age pension from your last or former jobs, from an early retirement pension, from disability or invalidity
   insurance or survivor pension from your spouse or partner's job.
   1. Yes
   5. No

   *IF (EP624_OccPensInc = a1)*

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 86 ---

EP678_AvPaymPens (APPROXIMATE ANUAL PAYMENT OF PENSIONS)
After taxes, what was the approximate **annual amount** received from all your occupational pensions in ^FLLastYear;?
Amount in ^FLCurr; Please exclude additional or extra, or lump-sum (one off) payments, such as bonuses, 13th month, Christmas and Summer pays.
NUMBER [0..100000000000000000]

   IF (EP678_AvPaymPens = NONRESPONSE)
   _
      |[Unfolding Bracket Sequence]
   ENDIF
   IF (MN101_Longitudinal = 1)
   _
      EP621_WhenSource_long (BENEFIT BEFORE LAST INTERVIEW)
         Did you start collecting your first occupational pension before our last interview in ^FLLastInterviewMonthYear;?
         The first occupational pension is the first occupational pension the R has started collecting.
         1. Yes, before last interview
         5. No, after last interview

   ENDIF
   IF ((NOT(MN101_Longitudinal = 1) OR (EP621_WhenSource_long = a5))
   _
      EP613_YearRecIncSource (YEAR RECEIVED INCOME SOURCE)
         In which year did you start collecting your first occupational pension?
         The first occupational pension is the first occupational pension the R has started collecting.
         NUMBER [1930..2024]

         IF (EP613_YearRecIncSource = RESPONSE)
         _
            CHECK: ( YEAR(CURRENTDATE) - EP613_YearRecIncSource <= MN808_AgeRespondent) [Year should be
            greater than or equal to birthyear. If year is correct, please press "suppress" and enter a remark to explain;]
         ENDIF
   ENDIF
EP681_LumpSumPenState (LUMP SUM PAYMENT INCOME SOURCE)
Did you receive any additional, or extra or lump-sum (one off) payment from any of your occupational pensions during the year ^FLLastYear;?
Please make sure that R takes into account all additional or extra or lump-sum (one off) payments received from any occupational pension (including bonuses, 13th month, Christmas and Summer pays, if any) to answer this question.
1. Yes
5. No

   IF (EP681_LumpSumPenState = a1)
   _
      EP682_TotAmountLS (TOTAL AMOUNT OF LUMP SUM PAYMENT FROM INCOME SOURCE)
         After taxes, about how much did you receive overall as additional or extra or lump-sum (one off) payments in ^FLLastYear; from your occupational pensions?
         Amount in ^FLCurr;
         Include all additional or extra or lump-sum (one off) payments
         NUMBER [0..100000000000000000]

         IF (EP682_TotAmountLS = NONRESPONSE)
         _
            |[Unfolding Bracket Sequence]
         ENDIF
   ENDIF
ENDIF
EP089_AnyRegPay (ANY OTHER REGULAR PAYMENTS RECEIVED)
Please look at card 27. Did you receive any of the following regular payments or transfers during the year ^FLLastYear;?
Code all that apply.;
SET OF 1. Life insurance payments from a private insurance company
2. Regular private annuity or private personal pension payments
3. Alimony
4. Regular payments from charities
5. Long-term care insurance payments from a private insurance company
96. None of these

CHECK: (NOT((count(EP089_AnyRegPay) > 1 AND ((96 IN (EP089_AnyRegPay)))) [You cannot select '96' together with any other answer. Please change your answer.;]
   LOOP cnt := 1 TO 5
   _
      IF ((cnt IN (EP089_AnyRegPay))
      _
         EP094_TotalAmountBenLP (TOTAL AMOUNT IN THE LAST PAYMENT)
            After any taxes and contributions, about how large was the average payment of{your life insurance payments from a private insurance company/ your regular private annuity or private personal pension payments/ your alimony/ your regular payments from charities/ your long-term care insurance payments from a private insurance company}
            in ^FLLastYear;?
            Amount in ^FLCurr;
            Do not include lump-sum payments. This will be asked later.
            NUMBER [0..100000000000000000]

            IF (EP094_TotalAmountBenLP = NONRESPONSE)
            _
               |[Unfolding Bracket Sequence]
            ENDIF
         EP090_PeriodPaym (PERIOD RECEIVED REGULAR PAYMENTS)
            Which period did that payment cover?
            1. One week
            2. Two weeks

--- page 87 ---

3. Calendar month/4 weeks
                    4. Three months/13 weeks
                    5. Six months/26 weeks
                    6. Full year/12 months/52 weeks
                    97. Other (specify)

                    IF (EP090_PeriodPaym = a97)
                    ⊟
                        EP091_OthPeriodPaym (OTHER PERIOD OF RECEIVING REGULAR PAYMENTS)

                            Specify other
                            STRING

                    ENDIF
                EP096_MonthsRegPaym (MONTHS RECEIVED REGULAR PAYMENTS)
                    For how many months altogether did you receive[life insurance payments from a private insurance company/ regular private annuity or private personal pension payments/ alimony/ regular payments from charities/ long-term care insurance payments from a private insurance company] in ^FLLastYear;?
                    NUMBER [1..12]

                EP092_AddPayments (ADDITIONAL PAYMENTS FOR THIS BENEFIT IN LAST YEAR)
                    For[your life insurance payments from a private insurance company/ your regular private annuity or private personal pension payments/ your alimony/ your regular payments from charities/ your long-term care insurance payments from a private insurance company], did you get additional or lump sum payments in ^FLLastYear;?
                    1. Yes
                    5. No

                    IF (EP092_AddPayments = a1)
                    ⊟
                        EP209_AddPaymAT (ADDITIONAL PAYMENTS AFTER TAXES)
                            After any taxes and contributions, about how much did you get in additional payments?
                            Amount in ^FLCurr;
                            NUMBER [0..100000000000000000]

                            IF (EP209_AddPaymAT = NONRESPONSE)
                            ⊟
                                |[Unfolding Bracket Sequence]
                                ENDIF
                    ENDIF
                [cnt]
            ENDIF
ENDLOOP    IF ((MN024_NursingHome = a1 AND (MN808_AgeRespondent < 76))
⊟
    EP097_PensClaim (PENSION CLAIMS)
        Now we are talking about pensions you might receive in the future but you do not receive currently. Will you be entitled to at least one pension listed on card 28 which you do not receive currently?
        1. Yes
        5. No

        IF (EP097_PensClaim = a1)
        ⊟
            EP098_TypeOfPension (TYPE OF PENSION YOU WILL BE ENTITLED TO)
                Which type or types of pension will you be entitled to?
                Code all that apply.;
                Respondent must not receive these pensions already
                SET OF 1. Public old age pension
                2. Public early retirement or pre-retirement pension
                3. Public disability insurance; sickness/invalidity/incapacity pension
                4. Private (occupational) old age pension
                5. Private (occupational) early retirement pension

                LOOP cnt := 1 TO 5
                ⊟
                        IF ((cnt IN (EP098_TypeOfPension))
                        ⊟
                            EP102_CompVolun (COMPULSORY OF VOLUNTARY PLAN OR FUND)
                                Is participation in[this public old age pension/ this public early retirement or pre-retirement pension/ this public disability insurance; sickness/invalidity/incapacity pension/ this private (occupational) old age pension/ this private (occupational) early retirement pension] compulsory or voluntary?
                                1. Compulsory
                                2. Voluntary

                            EP103_YrsContrToPlan (YEARS CONTRIBUTING TO PLAN)
                                How many years have you been contributing to[your public old age pension/ your public early retirement or pre-retirement pension/ your public disability insurance; sickness/invalidity/incapacity pension/ your private (occupational) old age pension/ your private (occupational) early retirement pension]?
                                Contribution by employer should be counted as well.
                                NUMBER [0..75]

                            CHECK: (EP103_YrsContrToPlan <= MN808_AgeRespondent) [Number should be less than or equal to respondent's age. If age is correct, please press "suppress" and enter a remark to explain;]
                            EP106_ExpRetAge (EXPECTED AGE TO COLLECT THIS PENSION)
                                At what age do you yourself expect to start collecting this pension payment for the first time?
                                NUMBER [30..75]

                            CHECK: (NOT((EP106_ExpRetAge < MN808_AgeRespondent AND (EP106_ExpRetAge = RESPONSE))) [Expected age should be higher than or equal to current age. If age is correct, please press "suppress" and enter a remark to explain;]
                                IF (EP005_CurrentJobSit = a2)
                                ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 88 ---

**EP609_PWExpPensStatAge** (EXPECTED AMOUNT OF PENSION BENEFIT)
            Please think about the time at which you will start collecting this pension. How much will be
            your first monthly benefit after taxes from *[your public old age pension/ your public early
            retirement or pre-retirement pension/ your public disability insurance;
            sickness/invalidity/incapacity pension/ your private (occupational) old age pension/ your
            private (occupational) early retirement pension]*?
            Amount in ^FLCurr;
            NUMBER [0..100000000000000000]

                        *ENDIF*
                     [cnt]
                  *ENDIF*
               *ENDLOOP*
            *ENDIF*
         *ENDIF*
         **EP210_IntCheck** (WHO ANSWERED SECTION EP)

            Who answered the questions in this section?
            1. Respondent only
            2. Respondent and proxy
            3. Proxy only

      *ENDIF*
      *IF (((IT IN (Test) OR ((ALL IN (Test))))*
      ⊟

            *IF (MN101_Longitudinal = 0)*
            ⊟
               **IT005_Continue** (INTRO IT MODULE)
                  Now we are going to talk about computers
                  1. Continue

                  *IF (Sec_EP.EP005_CurrentJobSit = a2)*
                  ⊟
                        **IT001_PC_work** (CURRENT JOB REQUIRES COMPUTER)
                           Does your current job require using a computer?
                           Computer could be a PC (Personal Computer), or a tablet (iPad or the like), or a smartphone (with internet access)
                           1. Yes
                           5. No

                     *ELSE*
                     ⊟
                              *IF (Sec_EP.EP005_CurrentJobSit = a1)*
                              ⊟
                                    **IT002_PC_work** (LAST JOB REQUIRED COMPUTER)
                                       Did your last job before retiring require using a computer?
                                       Computer could be a PC (Personal Computer), or a tablet (iPad or the like), or a smartphone (with internet
                                       access)
                                       1. Yes
                                       5. No

                                 *ENDIF*
                        *ENDIF*
               **IT003_PC_skills** (PC SKILLS)
               How would you rate your computer skills? Would you say they are...
               Read out.;; Computer could be a PC (Personal Computer), or a tablet (iPad or the like), or a smartphone (with internet
               access).
               1. Excellent
               2. Very good
               3. Good
               4. Fair
               5. Poor
               6. I never used a computer (SPONTANEOUS ONLY)

            *ENDIF*
            **IT004_UseWWW** (USE WORLD WIDE WEB)
            During the past 7 days, have you used the Internet, for e-mailing, searching for information, making purchases, or for any other
            purpose at least once?
            Any other purpose includes chatting, social networks, skyping etc.
            1. Yes
            5. No

      *ENDIF*
      *IF (((GS IN (Test) OR ((ALL IN (Test))))*
      ⊟

         **GS700_Intro** (INTRO HANDGRIP MEASURED)
            Now I would like to assess the strength of your hand in a gripping exercise. I will ask you to squeeze this handle as hard as you
            can, just for a couple of seconds and then let go. I will demonstrate it now.
            Demonstrate grip strength measure
            Start of a **Non-proxy section**. No proxy allowed.
            If the respondent is not doing test on her/his own please, press **CTRL-K** at each question.
            1. Continue

         **GS701_Willingness** (WILLING TO HAVE HANDGRIP MEASURED)
            I will take two alternate measurements from your right and your left hand. Would you be willing to have your handgrip strength
            measured?
            1. R agrees to take measurement
            2. R refuses to take measurement
            3. R is unable to take measurement

            *IF ((GS701_Willingness = a2 OR (GS701_Willingness = a3))*

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 89 ---

GS010_WhyNotCompl (WHY NOT COMPLETED GS TEST)

   Why didn't R complete the grip strength test?
   Code all that apply.;
   1. R felt it would not be safe
   2. IWER felt it would not be safe
   3. R refused, no reason given
   4. R tried but was unable to complete test
   5. R did not understand the instructions
   6. R had surgery, injury, swelling, etc. on both hands in past 6 months
   97. Other (Specify)

    IF ((a97 IN (GS010_WhyNotCompl))
    
         GS011_OthReason (OTHER REASON)

            Specify other reason
            STRING

    ENDIF
ENDIF
IF (NOT((GS701_Willingness = a2 OR (GS701_Willingness = a3)))

   GS002_RespStatus (RECORD RESPONDENT STATUS)

      Record respondent status
      1. Respondent has the use of both hands
      2. Respondent is unable to use right hand
      3. Respondent is unable to use left hand

ENDIF
IF ((GS701_Willingness = a2 OR (GS701_Willingness = a3))

   GS003_StopTest (END OF TEST BECAUSE RESPONDENT IS UNABLE OR NOT WILLING TO DO TEST)
      INTERVIEWER STOP TEST.
      No handgrip measurement to be taken.
      1. Continue

ENDIF
IF (NOT((GS701_Willingness = a2 OR (GS701_Willingness = a3)))

    IF (GS002_RespStatus = a1)
    
         GS004_DominantHand (DOMINANT HAND)
            Which is your dominant hand?
            Natural ambidexterity is the state of being born with equally adept in the use of both left and right hands, not
            adapted to.
            1. Right hand
            2. Left hand
            3. Ambidexterity

    ENDIF
GS705_IntroTest (INTRODUCTION TO TEST)

   Switch to recording booklet and follow instructions for grip strength measurement.
   Select '1. Continue' after the measurement.
   1. Continue

    IF ((GS002_RespStatus = a1 OR (GS002_RespStatus = a2))
    
         GS006_FirstLHand (FIRST MEASUREMENT, LEFT HAND)
            LEFT HAND, FIRST MEASUREMENT.
            Enter the results to the nearest integer value.
            NUMBER [0..100]

    ENDIF
    IF ((GS002_RespStatus = a1 OR (GS002_RespStatus = a3))
    
         GS008_FirstRHand (FIRST MEASUREMENT, RIGHT HAND)
            RIGHT HAND, FIRST MEASUREMENT.
            Enter the results to the nearest integer value.
            NUMBER [0..100]

    ENDIF
    IF ((GS002_RespStatus = a1 OR (GS002_RespStatus = a2))
    
         GS007_SecondLHand (SECOND MEASUREMENT, LEFT HAND)
            LEFT HAND, SECOND MEASUREMENT.
            Enter the results to the nearest integer value.
            NUMBER [0..100]

            IF (GS007_SecondLHand = RESPONSE)
            
                 CHECK: (NOT((GS007_SecondLHand <= GS006_FirstLHand - 20 OR (GS007_SecondLHand >=
                 GS006_FirstLHand20))) [The difference between the first and second measurement with the left hand is very
                 large; Have you entered the correct numbers?;]
                 ENDIF
         ENDIF

--- page 90 ---

IF ((GS002_RespStatus = a1 OR (GS002_RespStatus = a3))
   −
      GS009_SecondRHand (SECOND MEASUREMENT, RIGHT HAND)
         RIGHT HAND, SECOND MEASUREMENT.
         Enter the results to the nearest integer value.
         NUMBER [0..100]

         IF (GS009_SecondRHand = RESPONSE)
         −
               CHECK: (NOT((GS009_SecondRHand <= GS008_FirstRHand - 20 OR (GS009_SecondRHand >=
               GS008_FirstRHand20))) *[The difference between the first and second measurement with the left hand is very
               large; Have you entered the correct numbers?R;]*
            ENDIF
      ENDIF
   GS012_Effort (HOW MUCH EFFORT R GAVE)

   How much effort did R give to this measurement?
   1. R gave full effort
   2. R was prevented from giving full effort by illness, pain, or other symptoms or discomforts
   3. R did not appear to give full effort, but no obvious reason for this

   GS013_Position (THE POSITION OF R FOR THIS TEST)

   What was the R's position for this test?
   1. Standing
   2. Sitting
   3. Lying down

   GS014_RestArm (R RESTED HIS/HER ARMS ON A SUPPORT)

   Did R rest his/her arms on a support while performing this test?
   1. Yes
   5. No

      ENDIF
   ENDIF
IF (((SP IN (Test) OR ((ALL IN (Test)))
−
   SP001_Intro (INTRODUCTION SP)
      The next questions are about the help that you may have given to people you know or that you may have received from people
      you know.
      1. Continue

   SP002_HelpFrom (RECEIVED HELP FROM OTHERS)
      Please look at card 29. Thinking about the last twelve months, has any family member from outside the household, any friend or
      neighbour given you any kind of help listed on this card?
      1. Yes
      5. No

      IF (SP002_HelpFrom = a1)
      −
         SP003_FromWhoHelp (WHO GAVE YOU HELP)
            Which*[other]* family member from outside the household, friend or neighbour has helped you in the last twelve months?
            1. Spouse/Partner
            2. Mother
            3. Father
            4. Mother-in-law
            5. Father-in-law
            6. Stepmother
            7. Stepfather
            8. Brother
            9. Sister
            10. Child
            11. Step-child/your current partner's child
            12. Son-in-law
            13. Daughter-in-law
            14. Grandchild
            15. Grandparent
            16. Aunt
            17. Uncle
            18. Niece
            19. Nephew
            20. Other relative
            21. Friend
            22. (Ex-)colleague/co-worker
            23. Neighbour
            24. Ex-spouse/partner
            25. Minister, priest, or other clergy
            26. Therapist or other professional helper
            27. Housekeeper/Home health care provider
            96. None of these

            IF ((SP003_FromWhoHelp = a10 OR (SP003_FromWhoHelp = a11))
            −
               SP027_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
                  Which child?
                     ^FLChild[1];
                     ^FLChild[2];
                     ^FLChild[3];
                     ^FLChild[4];
                     ^FLChild[5];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 91 ---

^FLChild[6];
                        ^FLChild[7];
                        ^FLChild[8];
                        ^FLChild[9];
                        ^FLChild[10];
                        ^FLChild[11];
                        ^FLChild[12];
                        ^FLChild[13];
                        ^FLChild[14];
                        ^FLChild[15];
                        ^FLChild[16];
                        ^FLChild[17];
                        ^FLChild[18];
                        ^FLChild[19];
                        ^FLChild[20];
                        96. Another child;

                        IF (SP027_WhatChild = a96)
                        ⊟
                            SP023_NameOthChild (NAME OTHER CHILD)

                              Record child´s name
                              STRING

                        ENDIF
          ELSE
          ⊟

                IF (FoundAPotentialMatchingSNMember = 1)
                ⊟
                    SP028_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                        Is this {{Relationship string is loaded}} you mentioned earlier?
                        ^FLSnmember[1];
                        ^FLSnmember[2];
                        ^FLSnmember[3];
                        ^FLSnmember[4];
                        ^FLSnmember[5];
                        ^FLSnmember[6];
                        ^FLSnmember[7];
                        96. Another person;

                ENDIF
          ENDIF
SP004_TypesOfHelp (WHICH TYPES OF HELP)
Please look at card 29. Which types of help has this person provided in the last twelve months?
Code all that apply.;
SET OF 1. personal care, e.g. dressing, bathing or showering, eating, getting in or out of bed, using the toilet
2. practical household help, e.g. with home repairs, gardening, transportation, shopping, household chores
3. help with paperwork, such as filling out forms, settling financial or legal matters

SP005_HowOftenHelpRec (HOW OFTEN RECEIVED HELP FROM THIS PERSON)
In the last twelve months how often altogether have you received such help from this person? Was it...
Read out.;
1. About daily
2. About every week
3. About every month
4. Less often

  IF (piIndex <> 3)
  ⊟
        SP007_OtherHelper (ANY OTHER HELPER FROM OUTSIDE THE HOUSEHOLD)
            (Please look at card 29) Is there any other family member from outside the household, friend or neighbour who
            has given you personal care or practical household help?
            1. Yes
            5. No

  ENDIF
[1]    LOOP cnt1 := 2 TO 3
       ⊟
            IF (HelpFromOther[cnt1 - 1].SP007_OtherHelper = a1)
            ⊟
                SP003_FromWhoHelp (WHO GAVE YOU HELP)
                    Which[other] family member from outside the household, friend or neighbour has helped you in the last
                    twelve months?
                    1. Spouse/Partner
                    2. Mother
                    3. Father
                    4. Mother-in-law
                    5. Father-in-law
                    6. Stepmother
                    7. Stepfather
                    8. Brother
                    9. Sister
                    10. Child
                    11. Step-child/your current partner's child
                    12. Son-in-law
                    13. Daughter-in-law
                    14. Grandchild
                    15. Grandparent
                    16. Aunt
                    17. Uncle
                    18. Niece

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 92 ---

19. Nephew
20. Other relative
21. Friend
22. (Ex-)colleague/co-worker
23. Neighbour
24. Ex-spouse/partner
25. Minister, priest, or other clergy
26. Therapist or other professional helper
27. Housekeeper/Home health care provider
96. None of these

 IF ((SP003_FromWhoHelp = a10 OR (SP003_FromWhoHelp = a11))
 ⊟
      SP027_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
           Which child?
           ^FLChild[1];
           ^FLChild[2];
           ^FLChild[3];
           ^FLChild[4];
           ^FLChild[5];
           ^FLChild[6];
           ^FLChild[7];
           ^FLChild[8];
           ^FLChild[9];
           ^FLChild[10];
           ^FLChild[11];
           ^FLChild[12];
           ^FLChild[13];
           ^FLChild[14];
           ^FLChild[15];
           ^FLChild[16];
           ^FLChild[17];
           ^FLChild[18];
           ^FLChild[19];
           ^FLChild[20];
           96. Another child;

           IF (SP027_WhatChild = a96)
           ⊟
                SP023_NameOthChild (NAME OTHER CHILD)

                     Record child´s name
                     STRING

           ENDIF
 ELSE
 ⊟
           IF (FoundAPotentialMatchingSNMember = 1)
           ⊟
                SP028_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                     Is this {{Relationship string is loaded}} you mentioned earlier?
                     ^FLSNmember[1];
                     ^FLSNmember[2];
                     ^FLSNmember[3];
                     ^FLSNmember[4];
                     ^FLSNmember[5];
                     ^FLSNmember[6];
                     ^FLSNmember[7];
                     96. Another person;

           ENDIF
 ENDIF
SP004_TypesOfHelp (WHICH TYPES OF HELP)
 Please look at card 29. Which types of help has this person provided in the last twelve months?
 Code all that apply.;
 SET OF 1. personal care, e.g. dressing, bathing or showering, eating, getting in or out of bed, using the toilet
 2. practical household help, e.g. with home repairs, gardening, transportation, shopping, household chores
 3. help with paperwork, such as filling out forms, settling financial or legal matters

SP005_HowOftenHelpRec (HOW OFTEN RECEIVED HELP FROM THIS PERSON)
 In the last twelve months how often altogether have you received such help from this person? Was it...
 Read out.;
 1. About daily
 2. About every week
 3. About every month
 4. Less often

 IF (piIndex <> 3)
 ⊟
      SP007_OtherHelper (ANY OTHER HELPER FROM OUTSIDE THE HOUSEHOLD)
           (Please look at card 29) Is there any other family member from outside the household, friend or
           neighbour who has given you personal care or practical household help?
           1. Yes
           5. No

 ENDIF
[cnt1]
      ENDIF
 ENDLOOP
ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 93 ---

SP008_GiveHelp (GIVEN HELP IN THE TIME SINCE THE LAST INTERVIEW)
Now I would like to ask you about the help you have given to others.
Please look at card 29.
In the last twelve months, have you personally given any kind of help listed on this card to a family member from outside the household, a friend or neighbour?
QUESTION DOES NOT INCLUDE LOOKING AFTER YOUR OWN GRANDCHILDREN; THIS IS ASKED LATER IN SP014
1. Yes
5. No

   IF (SP008_GiveHelp = a1)
   ⊟
      SP009_ToWhomGiveHelp (TO WHOM DID YOU GIVE HELP)
      Which [other] family member from outside the household, friend or neighbour have you helped [most often] in the last twelve months?
      1. Spouse/Partner
      2. Mother
      3. Father
      4. Mother-in-law
      5. Father-in-law
      6. Stepmother
      7. Stepfather
      8. Brother
      9. Sister
      10. Child
      11. Step-child/your current partner's child
      12. Son-in-law
      13. Daughter-in-law
      14. Grandchild
      15. Grandparent
      16. Aunt
      17. Uncle
      18. Niece
      19. Nephew
      20. Other relative
      21. Friend
      22. (Ex-)colleague/co-worker
      23. Neighbour
      24. Ex-spouse/partner
      25. Minister, priest, or other clergy
      26. Therapist or other professional helper
      27. Housekeeper/Home health care provider
      96. None of these

      IF ((SP009_ToWhomGiveHelp = a10 OR (SP009_ToWhomGiveHelp = a11))
      ⊟
         SP029_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
         Which child?
            ^FLChild[1];
            ^FLChild[2];
            ^FLChild[3];
            ^FLChild[4];
            ^FLChild[5];
            ^FLChild[6];
            ^FLChild[7];
            ^FLChild[8];
            ^FLChild[9];
            ^FLChild[10];
            ^FLChild[11];
            ^FLChild[12];
            ^FLChild[13];
            ^FLChild[14];
            ^FLChild[15];
            ^FLChild[16];
            ^FLChild[17];
            ^FLChild[18];
            ^FLChild[19];
            ^FLChild[20];
            96. Another child;

            IF (SP029_WhatChild = a96)
            ⊟
               SP024_NameOthChild (NAME OTHER CHILD)

               Record child´s name
               STRING

            ENDIF
      ELSE
      ⊟
            IF (FoundAPotentialMatchingSNMember = 1)
            ⊟
               SP030_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
               Is this a [{Relationship string}] you mentioned earlier?
                  ^FLSNmember[1];
                  ^FLSNmember[2];
                  ^FLSNmember[3];
                  ^FLSNmember[4];
                  ^FLSNmember[5];
                  ^FLSNmember[6];
                  ^FLSNmember[7];
                  96. Another person;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 94 ---

ENDIF
         ENDIF
         SP010_TypesOfHelpGiven (WHICH TYPES OF HELP)
         Please look at card 29. Which types of help have you given to this person in the last twelve months?
         Code all that apply.;
         SET OF 1. personal care, e.g. dressing, bathing or showering, eating, getting in or out of bed, using the toilet
         2. practical household help, e.g. with home repairs, gardening, transportation, shopping, household chores
         3. help with paperwork, such as filling out forms, settling financial or legal matters

         SP011_HowOftGiveHelp (HOW OFTEN GIVE HELP)
         In the last twelve months, how often altogether have you given such help to this person? Was it...
         Read out.;
         1. About daily
         2. About every week
         3. About every month
         4. Less often

         IF (piIndex <> 3)
         ⊟
               SP013_GiveHelpToOth (HAVE YOU GIVEN HELP TO OTHERS)
               (Please look at card 29) Is there any other family member from outside the household, friend, or neighbour to
               whom you have given personal care or practical household help?
               1. Yes
               5. No

         ENDIF
[1]      LOOP cnt2 := 2 TO 3
         ⊟
               IF (HelpFromOutside[cnt2 - 1].SP013_GiveHelpToOth = a1)
               ⊟
                     SP009_ToWhomGiveHelp (TO WHOM DID YOU GIVE HELP)
                     Which [other] family member from outside the household, friend or neighbour have you helped [most often]
                     in the last twelve months?
                     1. Spouse/Partner
                     2. Mother
                     3. Father
                     4. Mother-in-law
                     5. Father-in-law
                     6. Stepmother
                     7. Stepfather
                     8. Brother
                     9. Sister
                     10. Child
                     11. Step-child/your current partner's child
                     12. Son-in-law
                     13. Daughter-in-law
                     14. Grandchild
                     15. Grandparent
                     16. Aunt
                     17. Uncle
                     18. Niece
                     19. Nephew
                     20. Other relative
                     21. Friend
                     22. (Ex-)colleague/co-worker
                     23. Neighbour
                     24. Ex-spouse/partner
                     25. Minister, priest, or other clergy
                     26. Therapist or other professional helper
                     27. Housekeeper/Home health care provider
                     96. None of these

                     IF ((SP009_ToWhomGiveHelp = a10 OR (SP009_ToWhomGiveHelp = a11))
                     ⊟
                           SP029_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
                           Which child?
                           ^FLChild[1];
                           ^FLChild[2];
                           ^FLChild[3];
                           ^FLChild[4];
                           ^FLChild[5];
                           ^FLChild[6];
                           ^FLChild[7];
                           ^FLChild[8];
                           ^FLChild[9];
                           ^FLChild[10];
                           ^FLChild[11];
                           ^FLChild[12];
                           ^FLChild[13];
                           ^FLChild[14];
                           ^FLChild[15];
                           ^FLChild[16];
                           ^FLChild[17];
                           ^FLChild[18];
                           ^FLChild[19];
                           ^FLChild[20];
                           96. Another child;

                           IF (SP029_WhatChild = a96)
                           ⊟
                           |

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 95 ---

SP024_NameOthChild (NAME OTHER CHILD)

            Record child´s name
            STRING

         ENDIF
      ELSE
      ⊟

         IF (FoundAPotentialMatchingSNMember = 1)
         ⊟

            SP030_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
               Is this a {[Relationship string}} you mentioned earlier?
               ^FLSNmember[1];
               ^FLSNmember[2];
               ^FLSNmember[3];
               ^FLSNmember[4];
               ^FLSNmember[5];
               ^FLSNmember[6];
               ^FLSNmember[7];
               96. Another person;

         ENDIF
      ENDIF
      SP010_TypesOfHelpGiven (WHICH TYPES OF HELP)
         Please look at card 29. Which types of help have you given to this person in the last twelve months?
         Code all that apply.;
         SET OF 1. personal care, e.g. dressing, bathing or showering, eating, getting in or out of bed, using the toilet
         2. practical household help, e.g. with home repairs, gardening, transportation, shopping, household chores
         3. help with paperwork, such as filling out forms, settling financial or legal matters

      SP011_HowOftGiveHelp (HOW OFTEN GIVE HELP)
         In the last twelve months, how often altogether have you given such help to this person? Was it...
         Read out.;
         1. About daily
         2. About every week
         3. About every month
         4. Less often

         IF (piIndex <> 3)
         ⊟

            SP013_GiveHelpToOth (HAVE YOU GIVEN HELP TO OTHERS)
               (Please look at card 29) Is there any other family member from outside the household, friend, or
               neighbour to whom you have given personal care or practical household help?
               1. Yes
               5. No

         ENDIF
      [cnt2]
   ENDIF
   ENDLOOP
ENDIF
IF ((Sec_CH.CH021_NoGrandChild > 0 OR (MN039_NumGrCh > 0))
⊟

   SP014_LkAftGrCh (LOOK AFTER GRANDCHILDREN)
      During the last twelve months, have you regularly or occasionally looked after[your grandchild/ your grandchildren]
      without the presence of the parents?
      1. Yes
      5. No

      IF (SP014_LkAftGrCh = a1)
      ⊟

         SP015_ParentLkAftGrChild (PARENTS FROM GRANDCHILDREN)
            Which of your children [is the parent of the grandchild/ are the parents of the grandchildren] you have looked
            after?
            Code all that apply.;
            SET OF ^FLChild[1];
            ^FLChild[2];
            ^FLChild[3];
            ^FLChild[4];
            ^FLChild[5];
            ^FLChild[6];
            ^FLChild[7];
            ^FLChild[8];
            ^FLChild[9];
            ^FLChild[10];
            ^FLChild[11];
            ^FLChild[12];
            ^FLChild[13];
            ^FLChild[14];
            ^FLChild[15];
            ^FLChild[16];
            ^FLChild[17];
            ^FLChild[18];
            ^FLChild[19];
            ^FLChild[20];
            21. deceased child(ren);

            LOOP cnt3 := 1 TO 20
            ⊟

               IF ((cnt3 IN (SP015_ParentLkAftGrChild))

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 96 ---

SP016_HowOftGrCh (HOW OFTEN DO YOU LOOK AFTER GRANDCHILDREN)
 On average, how often did you look after the child(ren) of ^FLChildName; in the last twelve months?
 Was it...
 Read out.;
 1. About daily
 2. About every week
 3. About every month
 4. Less often

 [cnt3]
 ENDIF
 ENDLOOP
 ENDIF
ENDIF
IF (MN013_HHSize > 1)

 SP018_GiveHelpInHH (GIVEN HELP TO SOMEONE IN THE HOUSEHOLD)
 Let us now talk about help within your household. Is there someone living in this household whom you have helped
 regularly during the last twelve months with personal care, such as washing, getting out of bed, or dressing?
 By regularly we mean daily or almost daily during at least three months. We do not want to capture help during short-
 term sickness of family members.
 1. Yes
 5. No

  IF (SP018_GiveHelpInHH = a1)

   SP019_ToWhomGiveHelpInHH (TO WHOM GIVEN HELP IN THIS HOUSEHOLD)
   Who is that?
   Code all that apply.;
   SET OF 1. Spouse/Partner
   2. Mother
   3. Father
   4. Mother-in-law
   5. Father-in-law
   6. Stepmother
   7. Stepfather
   8. Brother
   9. Sister
   10. Child
   11. Step-child/your current partner's child
   12. Son-in-law
   13. Daughter-in-law
   14. Grandchild
   15. Grandparent
   16. Aunt
   17. Uncle
   18. Niece
   19. Nephew
   20. Other relative
   21. Friend
   22. (Ex-)colleague/co-worker
   23. Neighbour
   24. Ex-spouse/partner
   25. Minister, priest, or other clergy
   26. Therapist or other professional helper
   27. Housekeeper/Home health care provider
   96. None of these

   CHECK: (NOT((count(SP019_ToWhomGiveHelpInHH) > 1 AND ((96 IN (SP019_ToWhomGiveHelpInHH)))) [You
   cannot select '96' together with any other answer. Please change your answer.;]
    IF (((a10 IN (SP019_ToWhomGiveHelpInHH) OR ((a11 IN (SP019_ToWhomGiveHelpInHH)))

     SP031_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
     Which child(ren)?
     SET OF ^FLChild[1];
      ^FLChild[2];
      ^FLChild[3];
      ^FLChild[4];
      ^FLChild[5];
      ^FLChild[6];
      ^FLChild[7];
      ^FLChild[8];
      ^FLChild[9];
      ^FLChild[10];
      ^FLChild[11];
      ^FLChild[12];
      ^FLChild[13];
      ^FLChild[14];
      ^FLChild[15];
      ^FLChild[16];
      ^FLChild[17];
      ^FLChild[18];
      ^FLChild[19];
      ^FLChild[20];
      96. Another child;

      IF ((a96 IN (SP031_WhatChild))

       SP025_NameOthChild (NAME OTHER CHILD)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 97 ---

Record child's name
                        STRING

                     ENDIF
               ELSE
               ▭
                     IF (FoundAPotentialMatchingSNMember = 1)
                     ▭
                          SP032_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                            Are these person(s) you mentioned earlier?
                            SET OF ^FLSNmember[1];
                            ^FLSNmember[2];
                            ^FLSNmember[3];
                            ^FLSNmember[4];
                            ^FLSNmember[5];
                            ^FLSNmember[6];
                            ^FLSNmember[7];
                            96. Another person;

                     ENDIF
               ENDIF
ENDIF
IF ((NOT((a96 IN (Sec_PH.Health_B2.PH048_HeADLa)) AND (NOT((a96 IN (Sec_PH.Health_B2.PH049_HeADLb))))
▭
     SP020_RecHelpPersCareInHH (SOMEONE IN THIS HOUSEHOLD HELPED YOU REGULARLY WITH PERSONAL CARE)
       And is there someone living in this household who has helped you regularly during the last twelve months with
       personal care, such as washing, getting out of bed, or dressing?
       By regularly we mean daily or almost daily during at least three months. We do not want to capture help during
       short-term sickness.
       1. Yes
       5. No

       IF (SP020_RecHelpPersCareInHH = a1)
       ▭
            SP021_FromWhomHelpInHH (WHO HELPES YOU WITH PERSONAL CARE IN THE HOUSEHOLD)
              Who is that?
              Code all that apply.;
              SET OF 1. Spouse/Partner
              2. Mother
              3. Father
              4. Mother-in-law
              5. Father-in-law
              6. Stepmother
              7. Stepfather
              8. Brother
              9. Sister
              10. Child
              11. Step-child/your current partner's child
              12. Son-in-law
              13. Daughter-in-law
              14. Grandchild
              15. Grandparent
              16. Aunt
              17. Uncle
              18. Niece
              19. Nephew
              20. Other relative
              21. Friend
              22. (Ex-)colleague/co-worker
              23. Neighbour
              24. Ex-spouse/partner
              25. Minister, priest, or other clergy
              26. Therapist or other professional helper
              27. Housekeeper/Home health care provider
              96. None of these

            CHECK: (NOT((count(SP021_FromWhomHelpInHH) > 1 AND ((96 IN (SP021_FromWhomHelpInHH)))) {You
            cannot select '96' together with any other answer. Please change your answer.;}
              IF (((a10 IN (SP021_FromWhomHelpInHH) OR ((a11 IN (SP021_FromWhomHelpInHH)))
              ▭
                   SP033_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
                     Which child(ren)?
                     SET OF ^FLChild[1];
                     ^FLChild[2];
                     ^FLChild[3];
                     ^FLChild[4];
                     ^FLChild[5];
                     ^FLChild[6];
                     ^FLChild[7];
                     ^FLChild[8];
                     ^FLChild[9];
                     ^FLChild[10];
                     ^FLChild[11];
                     ^FLChild[12];
                     ^FLChild[13];
                     ^FLChild[14];
                     ^FLChild[15];
                     ^FLChild[16];
                     ^FLChild[17];
                     ^FLChild[18];
                     ^FLChild[19];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 98 ---

^FLChild[20];
96. Another child;

 IF ((a96 IN (SP033_WhatChild))
 ⊟
     SP026_NameOthChild (NAME OTHER CHILD)
      Record child´s name
      STRING

 ENDIF
 ELSE
 ⊟
     IF (FoundAPotentialMatchingSNMember = 1)
     ⊟
         SP034_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
          Are these person(s) you mentioned earlier?
          SET OF ^FLSNmember[1];
          ^FLSNmember[2];
          ^FLSNmember[3];
          ^FLSNmember[4];
          ^FLSNmember[5];
          ^FLSNmember[6];
          ^FLSNmember[7];
          96. Another person;

     ENDIF
     ENDIF
     ENDIF
 ENDIF
SP022_IntCheck (WHO ANSWERED THE QUESTIONS IN SP)

 CHECK:
 Who answered the questions in this section?
 1. Respondent only
 2. Respondent and proxy
 3. Proxy only

ENDIF
IF (((FT IN (Test) OR ((ALL IN (Test)))
⊟
     IF (piMode = a1)
     ⊟
     ELSE
     ⊟
         IF (piMode = a2)
         ⊟
             CM003_RespFin (CHOICE RESPONDENT FINANCE)
              The following questions are about household and family finances, for example about your savings for old-age and
              financial support to children and other relatives. We only need to ask these questions of one of you. Which of you
              would be the one most able to answer questions about your finances?
              Code one only financial respondent
              1. ^MN002_Person[1].Name;
              2. ^MN002_Person[2].Name;

         ENDIF
     ENDIF
     IF (MN007_NumFinR = 1)
     ⊟
         FT001_Intro (INTRODUCTION FINANCIAL TRANSFERS)
          Some people provide financial or material gifts, or support to others such as parents, children, grandchildren, some other
          kin, or friends or neighbours, and some people don't.
          1. Continue

         FT002_GiveFiGift250 (GIVEN FINANCIAL GIFT 250 OR MORE)
          Now please think about the last twelve months. Not counting any shared housing or shared food, have
          you[or][your][husband/ wife/ partner] given any financial or material gift or support to any person inside or outside this
          household amounting to ^FL250; ^FLCurr; or more?
          By financial gift we mean giving money, or covering specific types of costs such as those for medical care or insurance,
          schooling, down payment for a home. Do not include loans or donations to charities.
          1. Yes
          5. No

          IF (FT002_GiveFiGift250 = a1)
          ⊟
              FT003_ToWhomFiGift250 (TO WHOM DID YOU PROVIDE FINANCIAL GIFT 250 OR MORE)
               To whom[else] did you[or][your][husband/ wife/ partner] provide a financial gift or assistance [in the last twelve
               months]?
               [Please name the person that you gave or helped most.]
               Instrument allows to go through the 'give' loop up to three times.
               1. Spouse/Partner
               2. Mother
               3. Father
               4. Mother-in-law
               5. Father-in-law
               6. Stepmother
               7. Stepfather
               8. Brother

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 99 ---

9. Sister
 10. Child
 11. Step-child/your current partner's child
 12. Son-in-law
 13. Daughter-in-law
 14. Grandchild
 15. Grandparent
 16. Aunt
 17. Uncle
 18. Niece
 19. Nephew
 20. Other relative
 21. Friend
 22. (Ex-)colleague/co-worker
 23. Neighbour
 24. Ex-spouse/partner
 25. Minister, priest, or other clergy
 26. Therapist or other professional helper
 27. Housekeeper/Home health care provider
 96. None of these

 IF ((FT003_ToWhomFiGift250 = a10 OR (FT003_ToWhomFiGift250 = a11))
 ⊟
      FT032_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
           Which child?
           ^FLChild[1];
           ^FLChild[2];
           ^FLChild[3];
           ^FLChild[4];
           ^FLChild[5];
           ^FLChild[6];
           ^FLChild[7];
           ^FLChild[8];
           ^FLChild[9];
           ^FLChild[10];
           ^FLChild[11];
           ^FLChild[12];
           ^FLChild[13];
           ^FLChild[14];
           ^FLChild[15];
           ^FLChild[16];
           ^FLChild[17];
           ^FLChild[18];
           ^FLChild[19];
           ^FLChild[20];
           96. Another child;

           IF (FT032_WhatChild = a96)
           ⊟
                FT022_NameOthChild (NAME OTHER CHILD)

                     Record child's name
                     STRING

           ENDIF
 ELSE
 ⊟
           IF (FoundAPotentialMatchingSNMember = 1)
           ⊟
                FT033_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                     Is this a {[Relationship string}} you mentioned earlier?
                     ^FLSNmember[1];
                     ^FLSNmember[2];
                     ^FLSNmember[3];
                     ^FLSNmember[4];
                     ^FLSNmember[5];
                     ^FLSNmember[6];
                     ^FLSNmember[7];
                     96. Another person;

           ENDIF
 ENDIF
 IF (pilIndex <> 3)
 ⊟
      FT007_OthPFiGift250 (OTHER PERSONS GIVEN FINANCIAL GIFT 250 OR MORE)
           Still thinking about the last twelve months: Is there anyone else inside or outside this household whom you[or][your][husband/ wife/ partner] have given any financial or material gift or support amounting to ^FL250; ^FLCurr; or more?
           1. Yes
           5. No

 ENDIF
[1]   LOOP cnt1 := 2 TO 3
 ⊟
           IF (FT_Given_FinancialAssistance_LOOP[cnt1 - 1].FT007_OthPFiGift250 = a1)
           ⊟
                FT003_ToWhomFiGift250 (TO WHOM DID YOU PROVIDE FINANCIAL GIFT 250 OR MORE)
                     To whom[else] did you[or][your][husband/ wife/ partner] provide a financial gift or assistance [in the last twelve months]?
                     [Please name the person that you gave or helped most.]

--- page 100 ---

Instrument allows to go through the 'give' loop up to three times.
1. Spouse/Partner
2. Mother
3. Father
4. Mother-in-law
5. Father-in-law
6. Stepmother
7. Stepfather
8. Brother
9. Sister
10. Child
11. Step-child/your current partner's child
12. Son-in-law
13. Daughter-in-law
14. Grandchild
15. Grandparent
16. Aunt
17. Uncle
18. Niece
19. Nephew
20. Other relative
21. Friend
22. (Ex-)colleague/co-worker
23. Neighbour
24. Ex-spouse/partner
25. Minister, priest, or other clergy
26. Therapist or other professional helper
27. Housekeeper/Home health care provider
96. None of these

 IF ((FT003_ToWhomFiGift250 = a10 OR (FT003_ToWhomFiGift250 = a11))
 ⊟
     FT032_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
         Which child?
         ^FLChild[1];
         ^FLChild[2];
         ^FLChild[3];
         ^FLChild[4];
         ^FLChild[5];
         ^FLChild[6];
         ^FLChild[7];
         ^FLChild[8];
         ^FLChild[9];
         ^FLChild[10];
         ^FLChild[11];
         ^FLChild[12];
         ^FLChild[13];
         ^FLChild[14];
         ^FLChild[15];
         ^FLChild[16];
         ^FLChild[17];
         ^FLChild[18];
         ^FLChild[19];
         ^FLChild[20];
         96. Another child;

         IF (FT032_WhatChild = a96)
         ⊟
             FT022_NameOthChild (NAME OTHER CHILD)

               Record child's name
               STRING

         ENDIF
 ELSE
 ⊟
         IF (FoundAPotentialMatchingSNMember = 1)
         ⊟
             FT033_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                 Is this a *{Relationship string}* you mentioned earlier?
                 ^FLSNmember[1];
                 ^FLSNmember[2];
                 ^FLSNmember[3];
                 ^FLSNmember[4];
                 ^FLSNmember[5];
                 ^FLSNmember[6];
                 ^FLSNmember[7];
                 96. Another person;

         ENDIF
 ENDIF
 IF (piIndex <> 3)
 ⊟
     FT007_OthPFiGift250 (OTHER PERSONS GIVEN FINANCIAL GIFT 250 OR MORE)
         Still thinking about the last twelve months: Is there anyone else inside or outside this
         household whom you*[or][your][husband/ wife/ partner]* have given any financial or material
         gift or support amounting to ^FL250; ^FLCurr; or more?
         1. Yes
         5. No

 ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 101 ---

[cnt1]
            *ENDIF*
         *ENDLOOP*
      *ENDIF*
**FT008_Intro2** (INTRODUCTION RECEIVE)
   We have just asked you about financial or material gifts or support that you may have given someone. Now we would like
   to know about such gifts and support that you may have received.
   1. Continue

**FT009_RecFiGift250** (RECEIVED FINANCIAL GIFT OF 250 OR MORE)
   Please think of the last twelve months. Not counting any shared housing or shared food, have you*[or][your][husband/*
   *wife/ partner]* **received** any financial or material gift or support from anyone inside or outside this household amounting
   to ^FL250; ^FLCurr; or more?
   By financial gift, we mean giving money as a gift or to cover specific types of costs such as those for medical care or
   insurance, schooling, down payment for a home. Do not include loans or inheritances.
   1. Yes
   5. No

   *IF (FT009_RecFiGift250 = a1)*
   ⊟
      **FT010_FromWhoFiGift250** (FROM WHOM RECEIVED FINANCIAL GIFT 250 OR MORE)
         Who*[else]* has given you*[or][your][husband/ wife/ partner]* a financial gift or assistance*[in the past twelve*
         *months]*? *[Please name the person that has given or helped you most.]*
         Instrument allows to go through the 'receive' loop up to three times
         1. Spouse/Partner
         2. Mother
         3. Father
         4. Mother-in-law
         5. Father-in-law
         6. Stepmother
         7. Stepfather
         8. Brother
         9. Sister
         10. Child
         11. Step-child/your current partner's child
         12. Son-in-law
         13. Daughter-in-law
         14. Grandchild
         15. Grandparent
         16. Aunt
         17. Uncle
         18. Niece
         19. Nephew
         20. Other relative
         21. Friend
         22. (Ex-)colleague/co-worker
         23. Neighbour
         24. Ex-spouse/partner
         25. Minister, priest, or other clergy
         26. Therapist or other professional helper
         27. Housekeeper/Home health care provider
         96. None of these

         *IF ((FT010_FromWhoFiGift250 = a10 OR (FT010_FromWhoFiGift250 = a11))*
         ⊟
            **FT034_WhatChild** (WHAT CHILD GIVEN FINANCIAL GIFT)
               Which child?
               ^FLChild[1];
               ^FLChild[2];
               ^FLChild[3];
               ^FLChild[4];
               ^FLChild[5];
               ^FLChild[6];
               ^FLChild[7];
               ^FLChild[8];
               ^FLChild[9];
               ^FLChild[10];
               ^FLChild[11];
               ^FLChild[12];
               ^FLChild[13];
               ^FLChild[14];
               ^FLChild[15];
               ^FLChild[16];
               ^FLChild[17];
               ^FLChild[18];
               ^FLChild[19];
               ^FLChild[20];
               96. Another child;

               *IF (FT034_WhatChild = a96)*
               ⊟
                  **FT023_NameOthChild** (NAME OTHER CHILD)

                     Record child's name
                     STRING

               *ENDIF*
         *ELSE*
         ⊟
               *IF (FoundAPotentialMatchingSNMember = 1)*
               ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 102 ---

FT035_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                Is this a *{Relationship string}* you mentioned earlier?
                ^FLSNmember[1];
                ^FLSNmember[2];
                ^FLSNmember[3];
                ^FLSNmember[4];
                ^FLSNmember[5];
                ^FLSNmember[6];
                ^FLSNmember[7];
                96. Another person;

        ENDIF
    ENDIF
    IF (piIndex <> 3)
    -
        FT014_FromOthPFiGift250 (FROM OTHER PERSONS RECEIVED FINANCIAL GIFT 250 OR MORE)
        (Still thinking about the last twelve months). Is there anyone else inside or outside this household who has given you*[or][your][husband/ wife/ partner]* any financial or material gift or support amounting to ^FL250; ^FLCurr; or more?
        1. Yes
        5. No

    ENDIF
[1]    LOOP cnt2 := 2 TO 3
    -
        IF (FT_Provide_FinancialAssistance_LOOP[cnt2 - 1].FT014_FromOthPFiGift250 = a1)
        -
            FT010_FromWhoFiGift250 (FROM WHOM RECEIVED FINANCIAL GIFT 250 OR MORE)
            Who*[else]* has given you*[or][your][husband/ wife/ partner]* a financial gift or assistance*[in the past twelve months]*? *[Please name the person that has given or helped you most.]*
            Instrument allows to go through the 'receive' loop up to three times
            1. Spouse/Partner
            2. Mother
            3. Father
            4. Mother-in-law
            5. Father-in-law
            6. Stepmother
            7. Stepfather
            8. Brother
            9. Sister
            10. Child
            11. Step-child/your current partner's child
            12. Son-in-law
            13. Daughter-in-law
            14. Grandchild
            15. Grandparent
            16. Aunt
            17. Uncle
            18. Niece
            19. Nephew
            20. Other relative
            21. Friend
            22. (Ex-)colleague/co-worker
            23. Neighbour
            24. Ex-spouse/partner
            25. Minister, priest, or other clergy
            26. Therapist or other professional helper
            27. Housekeeper/Home health care provider
            96. None of these

            IF ((FT010_FromWhoFiGift250 = a10 OR (FT010_FromWhoFiGift250 = a11))
            -
                FT034_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
                Which child?
                    ^FLChild[1];
                    ^FLChild[2];
                    ^FLChild[3];
                    ^FLChild[4];
                    ^FLChild[5];
                    ^FLChild[6];
                    ^FLChild[7];
                    ^FLChild[8];
                    ^FLChild[9];
                    ^FLChild[10];
                    ^FLChild[11];
                    ^FLChild[12];
                    ^FLChild[13];
                    ^FLChild[14];
                    ^FLChild[15];
                    ^FLChild[16];
                    ^FLChild[17];
                    ^FLChild[18];
                    ^FLChild[19];
                    ^FLChild[20];
                    96. Another child;

                IF (FT034_WhatChild = a96)
                -
                    FT023_NameOthChild (NAME OTHER CHILD)
                    Record child's name

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 103 ---

| STRING

                        *ENDIF*
                   *ELSE*
                   ⊟
                        *IF (FoundAPotentialMatchingSNMember = 1)*
                        ⊟
                             **FT035_WhatSNmember** (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                                  Is this a *{{Relationship string}}* you mentioned earlier?
                                  ^FLSNmember[1];
                                  ^FLSNmember[2];
                                  ^FLSNmember[3];
                                  ^FLSNmember[4];
                                  ^FLSNmember[5];
                                  ^FLSNmember[6];
                                  ^FLSNmember[7];
                                  96. Another person;

                        *ENDIF*
                   *ENDIF*
                   *IF (piIndex <> 3)*
                   ⊟
                        **FT014_FromOthPFiGift250** (FROM OTHER PERSONS RECEIVED FINANCIAL GIFT 250 OR MORE)
                             (Still thinking about the last twelve months). Is there anyone else inside or outside this
                             household who has given you*[or][your][husband/ wife/ partner]* any financial or material gift
                             or support amounting to ^FL250; ^FLCurr; or more?
                             1. Yes
                             5. No

                   *ENDIF*
                   [cnt2]
              *ENDIF*
         *ENDLOOP*
*ENDIF*
**FT015_EverRecInh5000** (EVER RECEIVED GIFT OR INHERITED MONEY 5000 OR MORE)
*[Not counting any large gift we may have already talked about/ Since our interview in]*, have you*[or][your][husband/ wife/ partner][ever/ {Preloaded month and year}]* **received** a gift or inherited money, goods, or property worth more than ^FL5000; ^FLCurr; ?
Not including any gifts you have already mentioned
1. Yes
5. No

*IF (FT015_EverRecInh5000 = a1)*
⊟
     *IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))*
     ⊟
          **FT016_YearRecInh5000** (IN WHICH YEAR GIFT OR INHERITANCE RECEIVED)
               *[Think of the largest gift or inheritance you received.]* In which year did you*[or][your][husband/ wife/ partner]* receive it?
               NUMBER [1905..2024]

     *ENDIF*
     **FT017_FromWhomRecInh5000** (FROM WHOM INHERITED 5000 OR MORE)
     From whom did you*[or][your][husband/ wife/ partner]* receive this gift or inheritance?
     1. Spouse/Partner
     2. Mother
     3. Father
     4. Mother-in-law
     5. Father-in-law
     6. Stepmother
     7. Stepfather
     8. Brother
     9. Sister
     10. Child
     11. Step-child/your current partner's child
     12. Son-in-law
     13. Daughter-in-law
     14. Grandchild
     15. Grandparent
     16. Aunt
     17. Uncle
     18. Niece
     19. Nephew
     20. Other relative
     21. Friend
     22. (Ex-)colleague/co-worker
     23. Neighbour
     24. Ex-spouse/partner
     25. Minister, priest, or other clergy
     26. Therapist or other professional helper
     27. Housekeeper/Home health care provider
     96. None of these

     *IF ((FT017_FromWhomRecInh5000 = a10 OR (FT017_FromWhomRecInh5000 = a11))*
     ⊟
          **FT036_WhatChild** (WHAT CHILD GIVEN FINANCIAL GIFT)
               Which child?
               ^FLChild[1];
               ^FLChild[2];
               ^FLChild[3];

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 104 ---

^FLChild[4];
            ^FLChild[5];
            ^FLChild[6];
            ^FLChild[7];
            ^FLChild[8];
            ^FLChild[9];
            ^FLChild[10];
            ^FLChild[11];
            ^FLChild[12];
            ^FLChild[13];
            ^FLChild[14];
            ^FLChild[15];
            ^FLChild[16];
            ^FLChild[17];
            ^FLChild[18];
            ^FLChild[19];
            ^FLChild[20];
            96. Another child;

            IF (FT036_WhatChild = a96)
            ⊟
                  FT024_NameOthChild (NAME OTHER CHILD)

                     Record child's name
                     STRING

               ENDIF
      ELSE
      ⊟
            IF (FoundAPotentialMatchingSNMember = 1)
            ⊟
                  FT037_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                     Is this a {Relationship string}} you mentioned earlier?
                     ^FLSNmember[1];
                     ^FLSNmember[2];
                     ^FLSNmember[3];
                     ^FLSNmember[4];
                     ^FLSNmember[5];
                     ^FLSNmember[6];
                     ^FLSNmember[7];
                     96. Another person;

            ENDIF
      ENDIF
      IF (piIndex <> 5)
      ⊟
         FT020_MoreRecInh5000 (ANY FURTHER GIFT OR INHERITANCE)
         Did you[or][your][husband/ wife/ partner] receive any further gift or inheritance worth more than ^FL5000;
         ^FLCurr;^FL_FT020_5;?
         1. Yes
         5. No

      ENDIF
[1]   LOOP cnt3 := 2 TO 5
      ⊟
            IF (FT_Receive_FinancialAssistance_LOOP[cnt3 - 1].FT020_MoreRecInh5000 = a1)
            ⊟
                  IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
                  ⊟
                        FT016_YearRecInh5000 (IN WHICH YEAR GIFT OR INHERITANCE RECEIVED)
                           {Think of the largest gift or inheritance you received.} In which year did
                           you[or][your][husband/ wife/ partner] receive it?
                           NUMBER [1905..2024]

                  ENDIF
                  FT017_FromWhomRecInh5000 (FROM WHOM INHERITED 5000 OR MORE)
                     From whom did you[or][your][husband/ wife/ partner] receive this gift or inheritance?
                     1. Spouse/Partner
                     2. Mother
                     3. Father
                     4. Mother-in-law
                     5. Father-in-law
                     6. Stepmother
                     7. Stepfather
                     8. Brother
                     9. Sister
                     10. Child
                     11. Step-child/your current partner's child
                     12. Son-in-law
                     13. Daughter-in-law
                     14. Grandchild
                     15. Grandparent
                     16. Aunt
                     17. Uncle
                     18. Niece
                     19. Nephew
                     20. Other relative
                     21. Friend
                     22. (Ex-)colleague/co-worker
                     23. Neighbour

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 105 ---

24. Ex-spouse/partner
                    25. Minister, priest, or other clergy
                    26. Therapist or other professional helper
                    27. Housekeeper/Home health care provider
                    96. None of these

                    IF ((FT017_FromWhomRecInh5000 = a10 OR (FT017_FromWhomRecInh5000 = a11))
                    ⊟
                         FT036_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
                              Which child?
                              ^FLChild[1];
                              ^FLChild[2];
                              ^FLChild[3];
                              ^FLChild[4];
                              ^FLChild[5];
                              ^FLChild[6];
                              ^FLChild[7];
                              ^FLChild[8];
                              ^FLChild[9];
                              ^FLChild[10];
                              ^FLChild[11];
                              ^FLChild[12];
                              ^FLChild[13];
                              ^FLChild[14];
                              ^FLChild[15];
                              ^FLChild[16];
                              ^FLChild[17];
                              ^FLChild[18];
                              ^FLChild[19];
                              ^FLChild[20];
                              96. Another child;

                              IF (FT036_WhatChild = a96)
                              ⊟
                                   FT024_NameOthChild (NAME OTHER CHILD)

                                        Record child's name
                                        STRING

                              ENDIF
                    ELSE
                    ⊟
                              IF (FoundAPotentialMatchingSNMember = 1)
                              ⊟
                                   FT037_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                                        Is this a {Relationship string}} you mentioned earlier?
                                        ^FLSNmember[1];
                                        ^FLSNmember[2];
                                        ^FLSNmember[3];
                                        ^FLSNmember[4];
                                        ^FLSNmember[5];
                                        ^FLSNmember[6];
                                        ^FLSNmember[7];
                                        96. Another person;

                              ENDIF
                         ENDIF
                         IF (piIndex <> 5)
                         ⊟
                              FT020_MoreRecInh5000 (ANY FURTHER GIFT OR INHERITANCE)
                                   Did you[or/your][husband/ wife/ partner] receive any further gift or inheritance worth more
                                   than ^FL5000; ^FLCurr;^FL_FT020_5;?
                                   1. Yes
                                   5. No

                         ENDIF
                    [cnt3]
                    ENDIF
               ENDLOOP
          ENDIF
FT025_EVER_GIFT_5000_OR_MORE (EVER GIVEN GIFT 5000 OR MORE)
[Not counting any large gift we may have already talked about/ Since our last interview in], have you[or/your][husband/
wife/ partner]^FL_FT025_7;[ever] given a gift of money, goods, or property worth more than ^FL5000; ^FLCurr; ?
Not including any gifts you have already mentioned
1. Yes
5. No

IF (FT025_EVER_GIFT_5000_OR_MORE = a1)
⊟
          IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
          ⊟
               FT026_YearGivInh5000 (IN WHICH YEAR GIFT GIVEN)
                    [Think of the largest gift you gave.] In which year did you[or/your][husband/ wife/ partner] give it?
                    NUMBER [1905..2024]

          ENDIF
     FT027_ToWhomGivInh5000 (TO WHOM GIVEN 5000 OR MORE)
     To whom did you[or/your][husband/ wife/ partner] give this gift?
     1. Spouse/Partner
     2. Mother

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 106 ---

3. Father
4. Mother-in-law
5. Father-in-law
6. Stepmother
7. Stepfather
8. Brother
9. Sister
10. Child
11. Step-child/your current partner's child
12. Son-in-law
13. Daughter-in-law
14. Grandchild
15. Grandparent
16. Aunt
17. Uncle
18. Niece
19. Nephew
20. Other relative
21. Friend
22. (Ex-)colleague/co-worker
23. Neighbour
24. Ex-spouse/partner
25. Minister, priest, or other clergy
26. Therapist or other professional helper
27. Housekeeper/Home health care provider
96. None of these

 IF ((FT027_ToWhomGivInh5000 = a10 OR (FT027_ToWhomGivInh5000 = a11))
 ⊟
      FT038_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
         Which child?
          ^FLChild[1];
          ^FLChild[2];
          ^FLChild[3];
          ^FLChild[4];
          ^FLChild[5];
          ^FLChild[6];
          ^FLChild[7];
          ^FLChild[8];
          ^FLChild[9];
          ^FLChild[10];
          ^FLChild[11];
          ^FLChild[12];
          ^FLChild[13];
          ^FLChild[14];
          ^FLChild[15];
          ^FLChild[16];
          ^FLChild[17];
          ^FLChild[18];
          ^FLChild[19];
          ^FLChild[20];
          96. Another child;

          IF (FT038_WhatChild = a96)
          ⊟
               FT028_NameOthChild (NAME OTHER CHILD)

                  Record child's name
                  STRING

          ENDIF
 ELSE
 ⊟
         IF (FoundAPotentialMatchingSNMember = 1)
         ⊟
              FT039_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                 Is this a {Relationship string}} you mentioned earlier?
                  ^FLSNmember[1];
                  ^FLSNmember[2];
                  ^FLSNmember[3];
                  ^FLSNmember[4];
                  ^FLSNmember[5];
                  ^FLSNmember[6];
                  ^FLSNmember[7];
                  96. Another person;

         ENDIF
 ENDIF
 IF (piIndex <> 5)
 ⊟
      FT031_MoreGivInh5000 (ANY FURTHER GIFT)
         Did you/[or][your][husband/ wife/ partner] give any further gift worth more than ^FL5000;
         ^FLCurr;^FL_FT031_4;?
         1. Yes
         5. No

 ENDIF
[1]    LOOP cnt4 := 2 TO 5
 ⊟
         IF (FT_Give_FinancialAssistance_LOOP[cnt4 - 1].FT031_MoreGivInh5000 = a1)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 107 ---

IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
         IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
            FT026_YearGivInh5000 (IN WHICH YEAR GIFT GIVEN)
               {Think of the largest gift you gave.} In which year did you{or}{your}{husband/ wife/ partner}
               give it?
               NUMBER [1905..2024]

         ENDIF
      FT027_ToWhomGivInh5000 (TO WHOM GIVEN 5000 OR MORE)
         To whom did you{or}{your}{husband/ wife/ partner} give this gift?
         1. Spouse/Partner
         2. Mother
         3. Father
         4. Mother-in-law
         5. Father-in-law
         6. Stepmother
         7. Stepfather
         8. Brother
         9. Sister
         10. Child
         11. Step-child/your current partner's child
         12. Son-in-law
         13. Daughter-in-law
         14. Grandchild
         15. Grandparent
         16. Aunt
         17. Uncle
         18. Niece
         19. Nephew
         20. Other relative
         21. Friend
         22. (Ex-)colleague/co-worker
         23. Neighbour
         24. Ex-spouse/partner
         25. Minister, priest, or other clergy
         26. Therapist or other professional helper
         27. Housekeeper/Home health care provider
         96. None of these

         IF ((FT027_ToWhomGivInh5000 = a10 OR (FT027_ToWhomGivInh5000 = a11))
            FT038_WhatChild (WHAT CHILD GIVEN FINANCIAL GIFT)
               Which child?
               ^FLChild[1];
               ^FLChild[2];
               ^FLChild[3];
               ^FLChild[4];
               ^FLChild[5];
               ^FLChild[6];
               ^FLChild[7];
               ^FLChild[8];
               ^FLChild[9];
               ^FLChild[10];
               ^FLChild[11];
               ^FLChild[12];
               ^FLChild[13];
               ^FLChild[14];
               ^FLChild[15];
               ^FLChild[16];
               ^FLChild[17];
               ^FLChild[18];
               ^FLChild[19];
               ^FLChild[20];
               96. Another child;

               IF (FT038_WhatChild = a96)
                  FT028_NameOthChild (NAME OTHER CHILD)

                     Record child's name
                     STRING

               ENDIF
         ELSE
            IF (FoundAPotentialMatchingSNMember = 1)
               FT039_WhatSNmember (WHAT SNMEMBER GIVEN FINANCIAL GIFT)
                  Is this a {{Relationship string}} you mentioned earlier?
                  ^FLSNmember[1];
                  ^FLSNmember[2];
                  ^FLSNmember[3];
                  ^FLSNmember[4];
                  ^FLSNmember[5];
                  ^FLSNmember[6];
                  ^FLSNmember[7];
                  96. Another person;

            ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 108 ---

ENDIF
                                IF (piIndex <> 5)
                                  ⊟
                                    |FT031_MoreGivInh5000 (ANY FURTHER GIFT)
                                      Did you[or][your][husband/ wife/ partner] give any further gift worth more than ^FL5000;
                                      ^FLCurr;^FL_FT031_4;?
                                      1. Yes
                                      5. No

                                  ENDIF
                              [cnt4]
                            ENDIF
                          ENDLOOP
                    ENDIF
              FT021_IntCheck (WHO ANSWERED THE QUESTIONS IN FT)

                CHECK:
                Who answered the questions in this section?
                1. Respondent only
                2. Respondent and proxy
                3. Proxy only

            ENDIF
        ENDIF
        IF (((HO IN (Test) OR ((ALL IN (Test)))
        ⊟
              IF ((MN008_NumHHR = 1 AND (MN024_NursingHome = a1))
              ⊟
                |HO001_Place (INTERVIEW IN HOUSE R)

                  Does the interview take place in the respondent's house or flat?
                  1. Yes
                  5. No

              ENDIF
              IF (MN008_NumHHR = 1)
              ⊟
                    IF (MN024_NursingHome = a2)
                    ⊟
                        |HO061_YrsAcc (YEARS IN ACCOMMODATION)
                          Now I have a few questions about your residence. How many years have you lived in your present
                          accommodation?
                          Round up to full years
                          NUMBER [1..120]

                        HO662_PayNursHome (OUT OF POCKET FOR NURSING HOME)
                          Do you have to pay "out of pocket" for your nursing home accommodation?
                          "Out of pocket" are expenses that are not reimbursed by private or public insurance or covered by benefits.
                          Expenses can be room, meals, care, laundry or charges and services, such as water, electricity, gas, or heating etc.
                          1. Yes
                          5. No

                          IF (HO662_PayNursHome = a1)
                          ⊟
                              |HO665_LastPayment (LAST PAYMENT)
                                Can you please estimate how much do you pay out of pocket for a typical month?
                                Amount in ^FLCurr;
                                NUMBER [0..100000000000000000]

                                IF (HO665_LastPayment = NONRESPONSE)
                                ⊟
                                    |[Unfolding Bracket Sequence]
                                  ENDIF
                              HO666_PayCoverNursHome (PAYMENT COVERING NURSING HOME)
                                Please look at card 30. What did this payment cover?
                                Code all that apply.;. Read out if necessary.
                                SET OF 1. Lodging (room)
                                2. Meals
                                3. Nursing and care services
                                4. Rehabilitation and other health services
                                5. Laundry
                                6. Charges and services, such as water, electricity, gas, or heating
                                7. Other expenses
                                96. None of the above

                              CHECK: (NOT((count(HO666_PayCoverNursHome) > 1 AND ((96 IN (HO666_PayCoverNursHome)))) [You
                              cannot select '96' together with any other answer. Please change your answer.;]
                              HO080_NHCosts (INCOME SOURCES USED TO COVER NURSING HOME EXPENSES)
                                It is important to understand how people cope with nursing home expenses. We have one more question to
                                assess how you manage. Please look at card 31. Which of these income sources are used in order to cover
                                your expenses?
                                Code all that apply.;
                                SET OF 1. Pensions (yours or your spouse)
                                2. Other sources of income, such as rents from real estate, annuities etc.
                                3. Assets or savings (yours or your spouse), including life insurance policies
                                4. Contributions from children or grandchildren
                                5. Housing allowances or other public benefits
                                6. Payments from a public long-term care insurance
                                7. Payments from a private long-term care insurance
                                97. Other income sources (specify)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 109 ---

IF ((a97 IN (HO080_NHCosts))
            ⊟
                HO081_OtherNHCosts (OTHER INCOME SOURCES USED TO COVER NURSING HOME EXPENSES)
                    What other income sources are used?
                    STRING

            ENDIF
        ENDIF
HO075_OwnRealEstate (OWN REAL ESTATE)
Do you own secondary homes, holiday homes, other real estate, land or forestry, including the home you occupied
before living in this NH?
Please do not include: time-sharing arrangement, own business
1. Yes
5. No

    IF (HO075_OwnRealEstate = a1)
    ⊟
        HO076_ValueRE (VALUE OF REAL ESTATE)
            In your opinion, how much would this or these properties be worth now if you sold it?
            If R owns property abroad, give value in ^FLCurr;
            NUMBER [0..100000000000000000]

        CHECK: (NOT((HO076_ValueRE = 0 AND (HO076_ValueRE = RESPONSE))) [Amount is expected to be higher
        than zero;]
            IF (HO076_ValueRE = NONRESPONSE)
            ⊟
                |[Unfolding Bracket Sequence]
            ENDIF
        HO077_RecIncRe (RECEIVE INCOME OR RENT OF REAL ESTATE )
            Did you receive any income or rent from these properties in ^FLLastYear;?
            1. Yes
            5. No

            IF (HO077_RecIncRe = a1)
            ⊟
                HO078_AmIncRe (AMOUNT INCOME OR RENT OF REAL ESTATE LAST YEAR)
                    How much income or rent did you receive from these properties during ^FLLastYear;, after taxes?
                    Amount in ^FLCurr;
                    NUMBER [0..100000000000000000]

                    IF (HO078_AmIncRe = NONRESPONSE)
                    ⊟
                        |[Unfolding Bracket Sequence]
                    ENDIF
            ENDIF
    ENDIF
ELSE
⊟
    IF (MN024_NursingHome = a1)
    ⊟
        HO002_OwnerTenant (OWNER, TENANT OR RENT FREE)
            Please look at card 32. Is your household occupying the dwelling you live in as
            Read out.;
            1. Owner
            2. Member of a cooperative
            3. Tenant
            4. Subtenant
            5. Rent free

            IF (((HO002_OwnerTenant = a1 OR (HO002_OwnerTenant = a2) OR (HO002_OwnerTenant = a5))
            ⊟
                HO067_PaymSimDwel (PAYMENT SIMILAR DWELLING)
                    In your opinion, how much would you pay as monthly rent if you rented a similar dwelling,
                    unfurnished, on the free market today?
                    Exclude charges and services such as electricity or heating. Amount in ^FLCurr;
                    NUMBER [0..100000000000000000]

                CHECK: (NOT((HO067_PaymSimDwel = 0 AND (HO067_PaymSimDwel = RESPONSE))) [Amount is
                expected to be higher than zero;]
                    IF (HO067_PaymSimDwel = NONRESPONSE)
                    ⊟
                        |[Unfolding Bracket Sequence]
                    ENDIF
            ENDIF
            IF ((HO002_OwnerTenant = a3 OR (HO002_OwnerTenant = a4))
            ⊟
                HO003_Period (RENT PAYMENT PERIOD)
                    [Coming back to your current rent and thinking about your last payment/ Thinking about your last
                    rent payment], what period did this cover? Was that
                    Read out.;
                    1. A week
                    2. A month
                    3. Three months
                    4. Six months
                    5. A year
                    97. Other period of time

                    IF (HO003_Period = a97)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 110 ---

HO004_OthPer (OTHER PERIOD)
            What other period do you mean?
            STRING

      ENDIF
   HO605_LastPayment (LAST PAYMENT)
      How much was your last gross rent payment, that is not subtracting housing subsidies or allowances
      you might get?
      Amount in ^FLCurr;
      NUMBER [0..100000000000000000]

   CHECK: (NOT((HO605_LastPayment = 0 AND (HO605_LastPayment = RESPONSE))) [Amount is
   expected to be higher than zero;]
      IF (HO605_LastPayment = NONRESPONSE)
         |[Unfolding Bracket Sequence]
      ENDIF
      IF (HO002_OwnerTenant = a3)
         HO079_SocialHousing (SOCIAL HOUSING)
            Do you live in a social or public housing accommodation, or equivalent?
            1. Yes
            5. No

      ENDIF
   HO007_LastPayIncl (LAST PAYMENT INCLUDE ALL CHARGES AND SERVICES)
      Did your last payment include all charges and services, such as water charges, garbage removal,
      upkeep of common space, electricity, gas, or heating?
      1. Yes
      5. No

      IF (HO007_LastPayIncl = a5)
         HO008_ExtRentIncl (CHARGES AND SERVICES)
            About how much did you pay for charges and services that were not included in your rent
            during the last[week/ month/ three months/ six months/ year]?
            Amount in ^FLCurr;
            NUMBER [0..100000000000000000]

            CHECK: (NOT((HO008_ExtRentIncl = 0 AND (HO008_ExtRentIncl = RESPONSE))) [Amount is
            expected to be higher than zero;]
               IF (HO008_ExtRentIncl = NONRESPONSE)
                  |[Unfolding Bracket Sequence]
               ENDIF
      ENDIF
      IF ((HO002_OwnerTenant = a3 OR (HO002_OwnerTenant = a4))
         HO010_BehRent (BEHIND WITH RENT)
            In the last twelve months, have you ever found yourself more than two months behind with
            your rent?
            1. Yes
            5. No

      ENDIF
ENDIF
IF ((HO002_OwnerTenant = a1 OR (HO002_OwnerTenant = a2))
   HO070_PercHouseOwn (PERCENTAGE HOUSE OWNED)
      What percentage or share of this dwelling is owned by you[and][your][husband/ wife/ partner]?
      Enter percentage
      For partners: The requested percentage refers to the sum of both shares.
      0 is allowed only if neither partner owns any fraction!
      NUMBER [0..100]

      IF (HO070_PercHouseOwn > 0)
         IF ((MN104_Householdmoved = 1 OR (MN101_Longitudinal = 0))
            HO611_AcqProp (HOW PROPERTY ACQUIRED)
               Please look at card 33. How did you acquire this property?
               Code all that apply.;
               If R received the property from the state without any payment code 6.
               SET OF 1. Purchased or built it with own means
               2. Purchased or built it with a loan or mortgage
               3. Purchased or built it with help from family
               4. Received it as a bequest
               5. Received it as a gift
               6. Acquired it through other means

               HO012_YearHouse (YEAR ACQUIRED THE HOUSE)
               In which year was that?
               NUMBER [1900..2024]

         ENDIF
         HO013_MortLoanProp (MORTGAGES OR LOANS ON PROPERTY)
            Do you have mortgages or loans on this property?
            1. Yes
            5. No

--- page 111 ---

IF (HO013_MortLoanProp = a1)
   ⊟
      HO014_YrsLMortLoan (YEARS LEFT OF MORTGAGE OR LOAN)
         How many years do your mortgages or loans on this property have left to run?
         If less than one year, code 1, if more than 50 or no fixed limit code 51
         NUMBER [1..51]

      HO015_AmToPayMortLoan (AMOUNT STILL TO PAY ON MORTGAGE OR LOAN)
         How much do you[or][your][husband/ wife/ partner] still have to pay on your
         mortgages or loans, excluding interest?
         Total amount in ^FLCurr;
         NUMBER [0..100000000000000000]

      CHECK: (NOT((HO015_AmToPayMortLoan = 0 AND (HO015_AmToPayMortLoan =
      RESPONSE))) [Amount is expected to be higher than zero;]
         IF (HO015_AmToPayMortLoan = NONRESPONSE)
            ⊟
               [[Unfolding Bracket Sequence]
            ENDIF
      HO017_RepayMortgLoans (REGULARLY REPAY MORTGAGE OR LOANS)
         Do you regularly repay your mortgages or loans?
         1. Yes
         5. No

         IF (HO17_RepayMortgLoans = a1)
         ⊟
            HO620_RegRepayMortLoan (AMOUNT REGULAR REPAYMENTS ON MORTGAGE OR LOAN)
               In the last twelve months, about how much did you pay for all mortgages and
               loans outstanding on this property?
               Amount in ^FLCurr;
               NUMBER [0..100000000000000000]

               CHECK: (NOT((HO620_RegRepayMortLoan = 0 AND (HO620_RegRepayMortLoan =
               RESPONSE))) [Amount is expected to be higher than zero;]
                  IF (HO620_RegRepayMortLoan = NONRESPONSE)
                     ⊟
                        [[Unfolding Bracket Sequence]
                     ENDIF
               HO022_BehRepayMortLoan (BEHIND WITH REPAYMENTS MORTGAGE OR LOAN)
                  In the last twelve months, have you ever found yourself more than two months
                  behind with these repayments?
                  1. Yes
                  5. No

            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF (HO002_OwnerTenant <> a5)
⊟
   HO023_SuBLAcc (SUBLET OR LET PARTS OF ACCOMMODATION)
      Do you[let/ sublet] parts of this accommodation?
      1. Yes
      5. No

      IF (HO023_SuBLAcc = a1)
      ⊟
         HO074_IncSuBLAcc (INCOME FROM SUBLET OR LET PARTS OF ACCOMMODATION)
            How much income or rent did you[or][your][husband/ wife/ partner] receive from letting this
            accommodation during ^FLLastYear;, after taxes?
            Amount in ^FLCurr;
            NUMBER [0..100000000000000000]

            IF (HO074_IncSuBLAcc = NONRESPONSE)
            ⊟
               [[Unfolding Bracket Sequence]
            ENDIF
         ENDIF
      ENDIF
ENDIF
IF ((HO002_OwnerTenant = a1 OR (HO002_OwnerTenant = a2))
⊟
   HO024_ValueH (VALUE OF THE HOUSE)
      In your opinion, how much would you receive if you sold your property today?
      Amount in ^FLCurr;
      NUMBER [0..100000000000000000]

   CHECK: (NOT((HO024_ValueH = 0 AND (HO024_ValueH = RESPONSE))) [Amount is expected to be
   higher than zero;]
      IF (HO024_ValueH = NONRESPONSE)
      ⊟
         [[Unfolding Bracket Sequence]
      ENDIF
ENDIF
IF ((MN104_Householdmoved = 1 OR (MN101_Longitudinal = 0))
⊟
   HO032_NoRoomSqm (NUMBER OF ROOMS)
      How many rooms do you have for your household members' personal use, including bedrooms but
      excluding kitchen, bathrooms, and hallways[and any rooms you may let or sublet]?

--- page 112 ---

Do not count boxroom, cellar, attic etc.
         NUMBER [1..25]

   ENDIF
HO633_SpecFeat (SPECIAL FEATURES IN THE HOUSE)
   Please look at card 34. Which of the following special features that assist people who have physical
   impairments or health problems does your home have, if any?
   Code all that apply.;
   SET OF 1. Widened doors or corridors
   2. Ramps or street level entrances
   3. Hand rails
   4. Automatic or easy open doors or gates
   5. Bathroom or toilet modifications
   6. Kitchen modifications
   7. Chair lifts or stair glides
   8. Alerting devices (button alarms, detectors...)
   96. None of these
   97. Other (specify)

CHECK: (NOT((count(HO633_SpecFeat) > 1 AND (96 IN (HO633_SpecFeat)))) [You cannot select '96'
together with any other answer. Please change your answer.;]
   IF ((a97 IN (HO633_SpecFeat))
   -
      HO631_SpecFeat (OTHER SPECIAL FEATURES)

         Note other feature
         STRING

   ENDIF
   IF ((MN104_Householdmoved = 1 OR (MN101_Longitudinal = 0))
   -
      HO034_YrsAcc (YEARS IN ACCOMMODATION)
         How many years have you been living in your present accommodation?
         Round up to full years
         NUMBER [0..120]

         IF (NOT(MN002_Person[2].RespId = Empty))
         -
            HO060_PartnerYrsAcc (PARTNER YEARS IN ACCOMMODATION)
               How many years has[your][husband/ wife/ partner] been living in your present
               accommodation?
               Round up to full years
               NUMBER [0..120]

      ENDIF
      IF (HO001_Place = a5)
      -
         HO636_TypeAcc (TYPE OF BUILDING)
            Please look at card 35.
            What type of building does your household live in?
            Read out.;
            A nursing home provides all of the following services for its residents: dispensing of
            medication, available, 24-hour personal assistance and supervision (not necessarily a nurse),
            and room & meals
            1. A farm house
            2. A free standing one or two family house
            3. A one or two family house as row or double house
            4. A building with 3 to 8 flats
            5. A building with 9 or more flats but no more than 8 floors
            6. A high-rise with 9 or more floors
            7. A housing complex with services for older people (residential home or sheltered housing, but
            not a nursing home)
            8. A nursing home

            IF ((HO636_TypeAcc = a7 OR (HO636_TypeAcc = a8))
            -
               HO782_Certifiednurse (At LEAST A NURSE)
                  Is there at least one (certified) nurse in the assistance or supervision staff?
                  1. Yes
                  5. No

         ENDIF
         HO043_StepstoEntrance (NUMBER OF STEPS TO ENTRANCE)
            How many steps have to be climbed (up or down) to get to the main entrance of your flat?
            Do not include steps that are avoided, because the block has an elevator
            1. Up to 5
            2. 6 to 15
            3. 16 to 25
            4. More than 25

         HO037_CityTown (AREA WHERE YOU LIVE)
            Please look at card 36.
            How would you describe the area where you live?
            Read out.;
            1. A big city
            2. The suburbs or outskirts of a big city
            3. A large town
            4. A small town
            5. A rural area or village

      ENDIF
HO054_Elevator (ELEVATOR)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 113 ---

Does your home have an elevator?
1. Yes
5. No

   *ENDIF*
**HO026_OwnSecHome** (OWN SECONDARY HOMES ETC)
   Do you*[or][your][husband/ wife/ partner]* own secondary homes, holiday homes, other real estate, land or
   forestry?
   Please do not include: time-sharing arrangement, own business
   1. Yes
   5. No

   *IF (HO026_OwnSecHome = a1)*
   ⊟
      **HO027_ValueRE** (VALUE OF REAL ESTATE)
         In your opinion, how much would this or these properties be worth now if you sold it?
         If owns property abroad, give value in ^FLCurr;
         NUMBER [0..1000000000000000000]

      **CHECK**: (NOT((HO027_ValueRe <= 0 AND (HO027_ValueRE = RESPONSE))) *[Amount is expected to
      be higher than zero;]*
         *IF (HO027_ValueRE = NONRESPONSE)*
         ⊟
            **[Unfolding Bracket Sequence]**
         *ENDIF*
      **HO029_RecIncRe** (RECEIVE INCOME OR RENT OF REAL ESTATE)
         Did you*[or][your][husband/ wife/ partner]* receive any income or rent from these properties in
         ^FLLastYear;?
         1. Yes
         5. No

         *IF (HO029_RecIncRe = a1)*
         ⊟
            **HO030_AmIncRe** (AMOUNT INCOME OR RENT OF REAL ESTATE LAST YEAR)
               How much income or rent did you*[or][your][husband/ wife/ partner]* receive from these
               properties during ^FLLastYear;, after taxes?
               Amount in ^FLCurr;
               NUMBER [0..100000000000000000]

               **CHECK**: (NOT((HO030_AmIncRe = 0 AND (HO030_AmIncRe = RESPONSE))) *[Amount is
               expected to be higher than zero;]*
                  *IF (HO030_AmIncRe = NONRESPONSE)*
                  ⊟
                     **[Unfolding Bracket Sequence]**
                  *ENDIF*
         *ENDIF*
   *ENDIF*
*ENDIF*
**HO041_IntCheck** (WHO ANSWERED THE QUESTIONS IN HO)

CHECK:
Who answered the questions in this section?
1. Respondent only
2. Respondent and proxy
3. Proxy only

   *ENDIF*
*ENDIF*
*IF (((HH IN (Test) OR ((ALL IN (Test))))*
⊟
   *IF (MN008_NumHHR = 1)*
   ⊟
      *IF (MN024_NursingHome = a1)*
      ⊟
         **HH001_OtherContribution** (OTHER CONTRIBUTION TO HOUSEHOLD INCOME)
            Although we may have asked you*[or other members of your household]* some of the details earlier, it is important
            for us to understand your household's situation correctly. In the last year, that is in ^FLLastYear;, was there any
            household member who contributed to your household income and who is not part of this interview?
            If necessary read list of eligibles: part of this interview are ^MN015_Eligibles;
            1. Yes
            5. No

         **HH010_OtherIncome** (INCOME FROM OTHER SOURCES)
            Some households receive payments such as housing allowances, child benefits, poverty relief etc.
            Has your household or anyone in your household received any such payments in ^FLLastYear;?
            1. Yes
            5. No

            *IF (HH010_OtherIncome = a1)*
            ⊟
               **HH011_TotAddHHinc** (ADDITIONAL INCOME RECEIVED BY ALL HOUSEHOLD MEMBERS IN LAST YEAR)
                  Please give us the approximate total amount of income from these benefits that you received as a household
                  in ^FLLastYear;, after taxes and contributions.
                  Here the giver is the government or a local authority. Please note that the annual amount is requested.
                  Amount in ^FLCurr;
                  NUMBER

               **CHECK**: (NOT((HH011_TotAddHHinc <= 0 AND (HH011_TotAddHHinc = RESPONSE))) *[Amount is expected to
               be higher than zero;]*

--- page 114 ---

IF (HH011_TotAddHHinc = NONRESPONSE)
                        ⊟
                           |[Unfolding Bracket Sequence]
                        ENDIF
                  ENDIF
            HH014_IntCheck (WHO ANSWERED THE QUESTIONS IN HH)
            |
            CHECK:
            Who answered the questions in this section?
            1. Respondent only
            2. Respondent and proxy
            3. Proxy only

                  ENDIF
            ENDIF
      ENDIF
IF (((CO IN (Test) OR ((ALL IN (Test)))
⊟
      IF (MN008_NumHHR = 1)
      ⊟
            IF (MN024_NursingHome = a1)
            ⊟
                  CO001_Intro1 (INTRODUCTION TEXT)
                  We would now like to ask some questions about your household's usual expenditures and how your household is
                  managing financially.
                  1. Continue

                  CO002_ExpFoodAtHome (AMOUNT SPENT ON FOOD AT HOME)
                  Thinking about the last 12 months: about how much did your household spend in a typical month on food to be
                  consumed at home?
                  Amount in ^FLCurr;
                  NUMBER

                  CHECK: (NOT((CO002_ExpFoodAtHome <= 0 AND (CO002_ExpFoodAtHome = RESPONSE))) [Amount is expected to
                  be higher than zero;]
                     IF (CO002_ExpFoodAtHome = NONRESPONSE)
                     ⊟
                        |[Unfolding Bracket Sequence]
                     ENDIF
                  CO003_ExpFoodOutsHme (AMOUNT SPENT ON FOOD OUTSIDE THE HOME)
                  Still thinking about the last 12 months:
                  about how much did your household spend in a typical month on food to be consumed outside home?
                  Amount in ^FLCurr;
                  NUMBER

                     IF (CO003_ExpFoodOutsHme = NONRESPONSE)
                     ⊟
                        |[Unfolding Bracket Sequence]
                     ENDIF
                  CO010_HomeProducedFood (CONSUME HOME PRODUCED FOOD)
                  Do you[and other members of your household] consume vegetables, fruit or meat that you have grown, produced,
                  caught or gathered yourselves?
                  1. Yes
                  5. No

                     IF (CO010_HomeProducedFood = a1)
                     ⊟
                           CO011_ValHomeProducedFood (VALUE OF HOME PRODUCED FOOD)
                           Thinking about the last 12 months, what is the value of the home produced food that you consumed in a
                           typical month? In other words, how much would you have paid for this food if you had to buy it?
                           Enter an amount in ^FLCurr;
                           NUMBER

                              IF (CO011_ValHomeProducedFood = NONRESPONSE)
                              ⊟
                                 |[Unfolding Bracket Sequence]
                              ENDIF
                     ENDIF
                  HH017_TotAvHHincMonth (TOTAL INCOME RECEIVED BY ALL HOUSEHOLD MEMBERS IN LAST MONTH)
                  How much was the overall income, after taxes and contributions, that your entire household had in an average
                  month in ^FLLastYear;?
                  Enter an amount in ^FLCurr;
                  NUMBER

                  CHECK: (NOT((HH017_TotAvHHincMonth <= 0 AND (HH017_TotAvHHincMonth = RESPONSE))) [Amount is expected
                  to be higher than zero;]
                     IF (HH017_TotAvHHincMonth = NONRESPONSE)
                     ⊟
                        |[Unfolding Bracket Sequence]
                     ENDIF
                  CO007_AbleMakeEndsMeet (IS HOUSEHOLD ABLE TO MAKE ENDS MEET)
                  Thinking of your household's total monthly income, would you say that your household is able to make ends
                  meet...
                  Read out.;
                  1. With great difficulty
                  2. With some difficulty
                  3. Fairly easily
                  4. Easily

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 115 ---

IF (MN032_socex = 1)
   ⊟
      CO206_AffordExpense (AFFORD EXPENSE)
         Could your household afford to pay an unexpected expense of 1000; ^FLCurr; without borrowing any
         money?
         1. Yes
         5. No

         CO209_PovertyPutUpWithCold (PUT UP WITH COLD)
            In the last twelve months, have you put up with feeling cold to save heating costs, to help you keep your
            living costs down?
            1. Yes
            5. No

         ENDIF
      CO009_IntCheck (WHO ANSWERED THE QUESTIONS IN CO)

         CHECK:
         Who answered the questions in this section?
         1. Respondent only
         2. Respondent and proxy
         3. Proxy only

         ENDIF
      ENDIF
   ENDIF
IF (((AS IN (Test) OR ((ALL IN (Test)))
⊟
      IF (MN007_NumFinR = 1)
      ⊟
         AS001_Intro1 (INTRODUCTION 1 TO ASSETS)
            The next questions ask about a number of different kinds of savings or investments that you[or][your][husband/ wife/
            partner] may have.
            1. Continue

         AS065_HasIndRetAcc (HAS INDIVIDUAL RETIREMENT ACCOUNTS)
            Do you[or][your][husband/ wife/ partner] currently have any money in individual retirement accounts?
            An individual retirement account is a retirement plan that lets the person put some money away each year, to be
            (partially) taken out at retirement time.
            1. Yes
            5. No

            IF (AS065_HasIndRetAcc = a1)
            ⊟
                  IF (MN005_ModeQues <> a1)
                  ⊟
                     AS020_IndRetAcc (WHO HAS INDIVIDUAL RETIREMENT ACCOUNTS)
                        Who has individual retirement accounts? You[, your][husband/ wife/ partner][or][both]?
                        1. Respondent only
                        2. [Husband/ Wife/ Partner] only
                        3. Both

                  ENDIF
                  IF ((MN005_ModeQues = a1 OR ((AS020_IndRetAcc = a1 OR (AS020_IndRetAcc = a3)))
                  ⊟
                     AS021_AmIndRet (AMOUNT INDIVIDUAL RETIREMENT ACCOUNTS)
                        How much do you currently have in individual retirement accounts?
                        Enter an amount in ^FLCurr;; code amount for respondent only
                        NUMBER [0..100000000000000000]

                        CHECK: (NOT(AS021_AmIndRet = Empty)) [Please enter a value;]
                        CHECK: (NOT((AS021_AmIndRet = 0 AND (AS021_AmIndRet = RESPONSE))) [Amount is expected to be
                        higher than zero;]
                           IF (AS021_AmIndRet = NONRESPONSE)
                           ⊟
                              [[Unfolding Bracket Sequence]
                           ENDIF
                     AS023_IndRetStockBo (INDIVIDUAL RETIREMENT ACCOUNTS MOSTLY IN STOCKS OR BONDS)
                        Are these individual retirement accounts mostly in stocks or mostly in bonds?
                        1. Mostly stocks
                        2. Half stocks and half bonds
                        3. Mostly bonds

                  ENDIF
                  IF ((AS020_IndRetAcc = a2 OR (AS020_IndRetAcc = a3))
                  ⊟
                     AS024_PAmIndRet (PARTNER AMOUNT INDIVIDUAL RETIREMENT ACCOUNTS)
                        How much does[your][husband/ wife/ partner] currently have in individual retirement accounts?
                        Amount in ^FLCurr;
                        Code amount for partner only
                        NUMBER [0..100000000000000000]

                        CHECK: (NOT(AS024_PAmIndRet = Empty)) [Please enter a value;]
                        CHECK: (NOT((AS024_PAmIndRet = 0 AND (AS024_PAmIndRet = RESPONSE))) [Amount is expected to be
                        higher than zero;]
                           IF (AS024_PAmIndRet = NONRESPONSE)
                           ⊟
                              [[Unfolding Bracket Sequence]
                           ENDIF
                     AS026_PIndRetStockBo (PARTNER INDIVIDUAL RETIREMENT ACCOUNTS MOSTLY IN STOCKS OR BONDS)

--- page 116 ---

Are these individual retirement accounts mostly in stocks or mostly in bonds?
            1. Mostly stocks
            2. Half stocks and half bonds
            3. Mostly bonds

         ENDIF
      ENDIF
      AS066_HasContSav (HAS CONTRACTUAL SAVING)
      Do you[or][your][husband/ wife/ partner] currently have any money in contractual saving for housing?
      Contractual savings for housing: an account at a financial institution that accumulates cash to be used towards the
      purchase of a house.
      1. Yes
      5. No

       IF (AS066_HasContSav = a1)
       ⊟
            AS027_AmContSav (AMOUNT CONTRACTUAL SAVING)
            About how much do you[and][your][husband/ wife/ partner] currently have in contractual saving for housing?
            Enter an amount in ^FLCurr;; code total amount for both partners
            NUMBER [0..100000000000000000]

            CHECK: (NOT(AS027_AmContSav = Empty)) [Please enter a value;]
            CHECK: (NOT((AS027_AmContSav = 0 AND (AS027_AmContSav = RESPONSE))) [Amount is expected to be higher
            than zero;]
               IF (AS027_AmContSav = NONRESPONSE)
               ⊟
                  |[Unfolding Bracket Sequence]
               ENDIF
      ENDIF
      AS067_HasLifeIns (HAS LIFE INSURANCE)
      Do you[or][your][husband/ wife/ partner] currently own any life insurance policies?
      1. Yes
      5. No

       IF (AS067_HasLifeIns = a1)
       ⊟
            AS029_LifeInsPol (LIFE INSURANCE POLICIES TERM OR WHOLE LIFE)
            Are your life insurance policies term policies, whole life policies, or both of these?
            Term life insurance provides coverage for a fixed period of time and pays a predetermined amount only if the
            policyholder dies within this period. On the other hand, whole life insurance has a savings component that
            increases in value over time and can be paid back in many installments over time or all at once.
            1. Term policies
            2. Whole life policies
            3. Both
            97. Other

            IF ((AS029_LifeInsPol = a2 OR (AS029_LifeInsPol = a3))
            ⊟
               AS030_ValLifePol (FACE VALUE LIFE POLICIES)
               What is the face value of the whole life policies owned by you[and][your][husband/ wife/ partner]?
               Amount in ^FLCurr; ; code total amount for both partners
               NUMBER [0..100000000000000000]

               CHECK: (NOT(AS030_ValLifePol = Empty)) [Please enter a value;]
               CHECK: (NOT((AS030_ValLifePol = 0 AND (AS030_ValLifePol = RESPONSE))) [Amount is expected to be
               higher than zero;]
                  IF (AS030_ValLifePol = NONRESPONSE)
                  ⊟
                     |[Unfolding Bracket Sequence]
                  ENDIF
            ENDIF
      ENDIF
      AS064_HasMutFunds (HAS MUTUAL FUNDS)
      Do you[or][your][husband/ wife/ partner] currently have any money in mutual funds or managed investment accounts?
      A mutual fund is a form of investment which is set up by a financial institution that collects money from many investors
      and gives it to a manager to invest it in stocks, bonds, and other financial products
      1. Yes
      5. No

       IF (AS064_HasMutFunds = a1)
       ⊟
            AS017_AmMutFunds (AMOUNT IN MUTUAL FUNDS)
            About how much do you[and][your][husband/ wife/ partner] currently have in mutual funds or managed
            investment accounts?
            Amount in ^FLCurr;; code total amount for both partners
            NUMBER [0..100000000000000000]

            CHECK: (NOT(AS017_AmMutFunds = Empty)) [Please enter a value;]
            CHECK: (NOT((AS017_AmMutFunds = 0 AND (AS017_AmMutFunds = RESPONSE))) [Amount is expected to be
            higher than zero;]
               IF (AS017_AmMutFunds = NONRESPONSE)
               ⊟
                  |[Unfolding Bracket Sequence]
               ENDIF
            AS019_MuFuStockBo (MUTUAL FUNDS MOSTLY STOCKS OR BONDS)
            Are these mutual funds and managed investment accounts mostly stocks or mostly bonds?
            1. Mostly stocks
            2. Half stocks and half bonds
            3. Mostly bonds

--- page 117 ---

ENDIF
AS063_HasStocks (HAS STOCKS)
  Do you[or][your][husband/ wife/ partner] currently have any money in stocks or shares that are listed or unlisted on
  stockmarket?
  Stocks are a form of investment that allows a person to own a part of a corporation and gives him/her the right to receive
  dividends from it.
  1. Yes
  5. No

  IF (AS063_HasStocks = a1)
  ⊟
       AS011_AmStocks (AMOUNT IN STOCKS)
         About how much do you[and][your][husband/ wife/ partner] currently have in stocks or shares that are listed or
         unlisted on stock market?
         Amount in ^FLCurr;; code total amount for both partners
         NUMBER [0..100000000000000000]

       CHECK: (NOT(AS011_AmStocks = Empty)) [Please enter a value;]
       CHECK: (NOT((AS011_AmStocks = 0 AND (AS011_AmStocks = RESPONSE))) [Amount is expected to be higher than
       zero;]
            IF (AS011_AmStocks = NONRESPONSE)
            ⊟
                 [Unfolding Bracket Sequence]
            ENDIF
  ENDIF
AS062_HasBonds (HAS BONDS)
  Do you[or][your][husband/ wife/ partner] currently have any money in government or corporate bonds?
  Bonds are a debt instrument issued by the government or a corporation in order to generate capital by borrowing.
  1. Yes
  5. No

  IF (AS062_HasBonds = a1)
  ⊟
       AS007_AmBonds (AMOUNT IN BONDS)
         About how much do you currently[and][your][husband/ wife/ partner] have in government or corporate bonds?
         Enter an amount in ^FLCurr;; code total amount for both partners
         NUMBER [0..100000000000000000]

       CHECK: (NOT(AS007_AmBonds = Empty)) [Please enter a value;]
       CHECK: (NOT((AS007_AmBonds = 0 AND (AS007_AmBonds = RESPONSE))) [Amount is expected to be higher than
       zero;]
            IF (AS007_AmBonds = NONRESPONSE)
            ⊟
                 [Unfolding Bracket Sequence]
            ENDIF
  ENDIF
AS060_HasBankAcc (HAS BANK ACCOUNT)
  Do you[or][your][husband/ wife/ partner] currently have a bank account, or transaction account, or saving account or
  postal account?
  1. Yes
  5. No

  IF (AS060_HasBankAcc = a1)
  ⊟
       AS003_AmBankAcc (AMOUNT BANK ACCOUNT)
         About how much do you[and][your][husband/ wife/ partner] currently have in bank accounts, transaction
         accounts, saving accounts or postal accounts?
         Amount in ^FLCurr;; code total amount for both partners
         NUMBER

       CHECK: (NOT(AS003_AmBankAcc = Empty)) [Please enter a value;]
            IF (AS003_AmBankAcc = NONRESPONSE)
            ⊟
                 [Unfolding Bracket Sequence]
            ENDIF
  ENDIF
  IF (((AS060_HasBankAcc = a1 OR (AS062_HasBonds = a1) OR (AS063_HasStocks = a1) OR (AS064_HasMutFunds =
  a1))
  ⊟
       AS070_IntIncome (INTEREST OR DIVIDEND)
         Overall, about how much interest or dividend income did you[and][your][husband/ wife/ partner] receive from
         your savings in bank accounts, bonds, stocks or mutual funds in ^FLLastYear;? Please give me the amount after
         taxes.
         Enter an amount in ^FLCurr;
         NUMBER [0..100000000000000000]

       CHECK: (NOT(AS070_IntIncome = Empty)) [Please enter a value;]
            IF (AS070_IntIncome = NONRESPONSE)
            ⊟
                 [Unfolding Bracket Sequence]
            ENDIF
  ENDIF
AS641_OwnFirm (OWN FIRM COMPANY BUSINESS)
  Do you[or][your][husband/ wife/ partner] currently own a firm, company, or business either entirely or as a partial
  ownership?
  1. Yes
  5. No

  IF (AS641_OwnFirm = a1)
  ⊟

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 118 ---

AS044_ShareFirm (PERCENTAGE SHARE FIRM OWNED)
            What percentage or share of this firm, company or business is owned by you[or][your][husband/ wife/ partner]?
            Enter percent. If less then 1 percent, type 1.
            NUMBER [1..100]

              IF (AS044_ShareFirm = RESPONSE)
              ⊟
                  |CHECK: (AS044_ShareFirm <= 100) [Percentage should be less or equal to 100;]
                ENDIF
              IF (AS044_ShareFirm = NONRESPONSE)
              ⊟
                  |[Unfolding Bracket Sequence]
                ENDIF
            AS642_AmSellFirm (AMOUNT SELLING FIRM)
            If the firm, company or business was sold and then paid off any debts on it, how much money would be left for
            you[or][your][husband/ wife/ partner]?
            Amount in ^FLCurr; ; code total amount for both partners
            NUMBER

            CHECK: (NOT(AS642_AmSellFirm = Empty)) [Please enter a value;]
              IF (AS642_AmSellFirm = NONRESPONSE)
              ⊟
                  |[Unfolding Bracket Sequence]
                ENDIF
          ENDIF
        AS649_NumCars (NUMBER OF CARS)
        How many cars do you[or][your][husband/ wife/ partner] own? Please exclude company cars and leased cars.
        NUMBER [0..10]

          IF (AS649_NumCars > 0)
          ⊟
              AS051_AmSellingCars (AMOUNT SELLING CARS)
              If you sold[this/ these][car/ cars] about how much would you get?
              Amount in ^FLCurr;; code total amount for both partners
              NUMBER [0..100000000000000000]

              CHECK: (NOT(AS051_AmSellingCars = Empty)) [Please enter a value;]
                IF (AS051_AmSellingCars = NONRESPONSE)
                ⊟
                    |[Unfolding Bracket Sequence]
                  ENDIF
          ENDIF
        AS054_OweMonAny (OWE MONEY)
        The next question refers to money that you may owe, excluding mortgages or money owed on land, property or firms (if
        any). Looking at card 41, which of these types of debts do you[or][your][husband/ wife/ partner] currently have, if any?
        Code all that apply.;
        SET OF 1. Debt on cars and other vehicles (vans/motorcycles/boats, etc.)
        2. Debt on credit cards / store cards
        3. Loans (from bank, building society or other financial institution)
        4. Debts to relatives or friends
        5. Student loans
        6. Overdue bills (phone, electricity, heating, rent)
        96. None of these
        97. Other

        CHECK: (NOT((count(AS054_OweMonAny) > 1 AND ((a96 IN (AS054_OweMonAny)))) [You cannot select '96' together with
        any other answer. Please change your answer.;]
          IF (NOT(((96 IN (AS054_OweMonAny) AND (count(AS054_OweMonAny) = 1)))
          ⊟
              AS055_AmOweMon (AMOUNT OWING MONEY IN TOTAL)
              Not including mortgages or money owed on land, property or firms, how much do you[and][your][husband/ wife/
              partner] owe in total?
              Amount in ^FLCurr;; code total amount for both partners
              NUMBER

              CHECK: (NOT(AS055_AmOweMon = Empty)) [Please enter a value;]
              CHECK: (NOT((AS055_AmOweMon = 0 AND (AS055_AmOweMon = RESPONSE))) [Amount is expected to be higher
              than zero;]
                IF (AS055_AmOweMon = NONRESPONSE)
                ⊟
                    |[Unfolding Bracket Sequence]
                  ENDIF
          ENDIF
        AS057_IntCheck (WHO ANSWERED THE QUESTIONS IN AS)

          CHECK:
          Who answered the questions in this section?
          1. Respondent only
          2. Respondent and proxy
          3. Proxy only

        ENDIF
      ENDIF
      IF (((AC IN (Test) OR ((ALL IN (Test)))
      ⊟
          AC011_Intro (INTRODUCTION WELL-BEING)
          We are also interested in how people think about their lives in general.
          Start of a Non-proxy section. No proxy allowed. If the respondent is not capable of answering any of these questions on
          her/his own, press CTRL-K at each question.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 119 ---

1. Continue

AC012_HowSat (HOW SATISFIED WITH LIFE)
  On a scale from 0 to 10 where 0 means completely dissatisfied and 10 means completely satisfied, how satisfied are you with
  your life?
  NUMBER [0...10]

AC013_Intro (INTRODUCTION CASP ITEMS)
  Please look at card 42. I will now read a list of statements that people have used to describe their lives or how they feel. We
  would like to know how often, if at all, you experienced the following feelings and thoughts: often, sometimes, rarely, or never.
  1. Continue

AC014_AgePrev (AGE PREVENTS FROM DOING THINGS)
  How often do you think your age prevents you from doing the things you would like to do?
  Card 42. Read out.;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC015_OutofContr (OUT OF CONTROL)
  How often do you feel that what happens to you is out of your control?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC016_LeftOut (FEEL LEFT OUT OF THINGS)
  How often do you feel left out of things?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC017_DoWant (DO THE THINGS YOU WANT TO DO)
  How often do you think that you can do the things that you want to do?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC018_FamRespPrev (FAMILY RESPONSIBILITIES PREVENT)
  How often do you think that family responsibilities prevent you from doing what you want to do?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC019_ShortMon (SHORTAGE OF MONEY STOPS)
  How often do you think that shortage of money stops you from doing the things you want to do?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC020_EachDay (LOOK FORWARD TO EACH DAY)
  How often do you look forward to each day?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC021_LifeMean (LIFE HAS MEANING)
  How often do you feel that your life has meaning?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC022_BackHapp (LOOK BACK ON LIFE WITH HAPPINESS)
  How often, on balance, do you look back on your life with a sense of happiness?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC023_FullEnerg (FEEL FULL OF ENERGY)
  How often do you feel full of energy these days?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

AC024_FullOpport (FULL OF OPPORTUNITIES)
  How often do you feel that life is full of opportunities?
  Card 42. Read out.Need;

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 120 ---

1. Often
2. Sometimes
3. Rarely
4. Never

**AC025_FutuGood** (FUTURE LOOKS GOOD)
  How often do you feel that the future looks good for you?
  Card 42. Read out.Need;
  1. Often
  2. Sometimes
  3. Rarely
  4. Never

  IF (MN024_NursingHome = a1)
  ⊟

      **AC001_Intro** (INTRODUCTION AC ACTIVITIES)
        Now I have a few questions about activities you may do.
        1. Continue

      **AC035_ActPastTwelveMonths** (ACTIVITIES IN LAST YEAR)
        Please look at card 43: which of the activities listed on this card - if any - have you done in the last twelve months?
        Code all that apply.;
        SET OF 1. Done voluntary or charity work
        4. Attended an educational or training course
        5. Gone to a sport, social or other kind of club
        7. Taken part in a political or community-related organization
        8. Read books, magazines or newspapers
        9. Did word or number games such as crossword puzzles or Sudoku
        10. Played cards or games such as chess
        96. None of these

      **CHECK**: (NOT((count(AC035_ActPastTwelveMonths) > 1 AND ((a96 IN (AC035_ActPastTwelveMonths)))) [You cannot select
      '96' together with any other answer. Please change your answer.;]
        IF ((count(AC035_ActPastTwelveMonths) = 1 AND ((a96 IN (AC035_ActPastTwelveMonths)))
        ⊟

            **AC038_HowSatisfiedNoAct** (SATISFIED WITH NO ACTIVITIES)
              You indicated that you do not engage in any of the activities on Card 43. On a scale from 0 to 10 where 0 means
              completely dissatisfied and 10 means completely satisfied, how satisfied are you with this?
              NUMBER [0..10]

        ELSE
        ⊟

            IF (((((((a1 IN (AC035_ActPastTwelveMonths) OR ((a4 IN (AC035_ActPastTwelveMonths)) OR ((a5 IN
            (AC035_ActPastTwelveMonths)) OR ((a7 IN (AC035_ActPastTwelveMonths)) OR ((a8 IN
            (AC035_ActPastTwelveMonths)) OR ((a9 IN (AC035_ActPastTwelveMonths)) OR ((a10 IN
            (AC035_ActPastTwelveMonths)))
            ⊟

                  LOOP cnt1 := 1 TO 10
                  ⊟

                      IF ((cnt1 IN (AC035_ActPastTwelveMonths))
                      ⊟

                          **AC036_HowOftAct** (HOW OFTEN ACTIVITY IN THE LAST TWELVE MONTHS)
                            How often in the past twelve months[did/ have][you][do voluntary or charity work/ attended
                            an educational or training course/ go to a sport, social or other kind of club/ taken part in a
                            political or community-related organization/ read books, magazines or newspapers/ do word or
                            number games such as crossword puzzles or Sudoku/ played cards or games such as chess]?
                            Read out.;.
                            1. Almost daily
                            2. Almost every week
                            3. Almost every month
                            4. Less often

                          [cnt1]
                      ENDIF
                  ENDLOOP
              **AC037_HowSatisfied** (SATISFIED WITH ACTIVITIES)
                On a scale from 0 to 10 where 0 means completely dissatisfied and 10 means completely satisfied, how
                satisfied are you with the activities that you mentioned?
                NUMBER [0..10]

            ENDIF
        ENDIF
  ENDIF
  IF ((MN101_Longitudinal = 0 OR (MN101_Longitudinal = Empty))
  ⊟

      **AC700_BigFiveIntro** (INTRODUCTION BIG FIVE)
        Please look at card 44.
        I am now going to read out some statements concerning characteristics that may or may not apply to you.
        After each statement please indicate if whether you strongly disagree, disagree a little, neither agree nor disagree, agree
        a little or agree strongly.
        1. Continue

      **AC701_Reserved** (BIG FIVE - RESERVED)
        I see myself as someone who is reserved.
        Do you...
        Read out.;
        1. Disagree strongly
        2. Disagree a little
        3. Neither agree nor disagree
        4. Agree a little

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 121 ---

5. Agree strongly

**AC702_Trust** (BIG FIVE - TRUST)
   I see myself as someone who is generally trusting.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC703_Lazy** (BIG FIVE - LAZY)
   I see myself as someone who tends to be lazy.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC704_Relaxed** (BIG FIVE - RELAXED)
   I see myself as someone who is relaxed, handles stress well.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC705_FewInterests** (BIG FIVE - FEW INTERESTS)
   I see myself as someone who has few artistic interests.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC706_Outgoing** (BIG FIVE - OUTGOING)
   I see myself as someone who is outgoing, sociable.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC707_FindFault** (BIG FIVE - FINDFAULT)
   I see myself as someone who tends to find fault with others.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC708_Thorough** (BIG FIVE - THOROUGH JOB)
   I see myself as someone who does a thorough job.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC709_Nervous** (BIG FIVE - NERVOUS)
   I see myself as someone who gets nervous easily.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC710_Imagination** (BIG FIVE - IMAGINATION)
   I see myself as someone who has an active imagination.
   Do you...
   Read out if necessary
   1. Disagree strongly
   2. Disagree a little
   3. Neither agree nor disagree
   4. Agree a little
   5. Agree strongly

**AC711_Kind** (BIG FIVE - KIND)
   I see myself as someone who is considerate and kind to almost everyone.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 122 ---

Do you...
         Read out.Need;
         1. Disagree strongly
         2. Disagree a little
         3. Neither agree nor disagree
         4. Agree a little
         5. Agree strongly

      ENDIF
      AC740_Outro (NON PROXY)

      CHECK: Who answered the questions in this section?
      1. Respondent
      2. Section not answered (proxy interview)

   ENDIF
   IF (((TE IN (Test) OR ((ALL IN (Test)))
   ___ 
         IF (MN101_Longitudinal = 1)
         ___ 
               IF (MN024_NursingHome = a1)
               ___ 
                     TE001_intro (INTRO TIME EXPENDITURE)
                       The following questions are about how you spent your time yesterday.
                       1. Continue

                     TE002_Weekday (WHAT DAY YESTERDAY)

                       Do not read out.
                       Please note what day YESTERDAY was.
                       1. Monday
                       2. Tuesday
                       3. Wednesday
                       4. Thursday
                       5. Friday
                       6. Saturday
                       7. Sunday

                     TE003_YesterdaySpecial (NORMAL DAY YESTERDAY)
                       Please think about YESTERDAY which was [monday/ tuesday/ wednesday/ thursday/ friday/ saturday/ sunday],
                       from the morning until the end of the day. Think about where you were, what you were doing, who you were with,
                       and how you felt. Was yesterday a normal day for you or did something unusual, bad or good happen?
                       Read out.;
                       1. Yes - just a normal day
                       2. No – my day included unusual bad or stressful things
                       3. No – my day included unusual good things

                     TE004_Chores_INTRO (TIME SPENT ON CHORES)
                       Continue to think about yesterday, from the morning until the end of the day, and the amount of time you spent
                       on diverse activities over the course of the day. How much time did you spend yesterday on household chores like
                       cleaning, laundry, shopping, cooking, gardening, etc. Please do NOT include personal care or care for children,
                       parents or other family members.


                       If respondent is not sure, then ask [him/ her] to estimate the amount of time as best as [he/ she] can.
                       If respondent did not spend any time on a certain activity, enter 0 in both fields.
                       If respondent spent for example an hour and a half on a certain activity, then enter 1 hour and 30 minutes.
                       If respondent spent 40 minutes on a certain activity, enter 0 hours and 40 minutes.
                       1. Continue

                     TE005_Chores_Hrs (HOURS SPENT ON CHORES)
                       Hours:
                       NUMBER [0..24]

                     TE006_Chores_Mts (MINUTES SPENT ON CHORES)
                       Minutes:
                       NUMBER [0..59]

                     CHECK: (NOT((TE005_Chores_Hrs = 24 AND (TE006_Chores_Mts > 0))) [Are you sure? Value seems unlikely.;]
                     TE010_PersonalCare_Intro (TIME SPENT ON PERSONAL CARE)
                       How much time did you spend yesterday on personal care, such as washing, dressing, visiting the hairdresser,
                       seeing the doctor, etc.?

                       1. Continue

                     TE011_PersonalCare_Hrs (HOURS SPENT ON PERSONAL CARE)
                       Hours:
                       NUMBER [0..24]

                     TE012_PersonalCare_Mts (MINUTES SPENT ON PERSONAL CARE)
                       Minutes:
                       NUMBER [0..59]

                     CHECK: (NOT((TE011_PersonalCare_Hrs = 24 AND (TE012_PersonalCare_Mts > 0))) [Are you sure? Value seems
                     unlikely.;]
                     TE013_Children_Intro (TIME SPENT ON PERSONAL CHILDREN)
                       How much time did you spend yesterday on activities with your children, grandchildren, children you baby-sit or
                       any other children you look after? This can include washing, dressing, playing, taking to school/other activities,
                       helping with homework etc.


                       Please exclude adult children.
                       1. Continue

--- page 123 ---

TE014_Children_Hrs (HOURS SPENT ON CHILDREN)
  Hours:
  NUMBER [0..24]

TE015_Children_Mts (MINUTES SPENT ON CHILDREN)
  Minutes:
  NUMBER [0..59]

CHECK: (NOT((TE014_Children_Hrs = 24 AND (TE015_Children_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
TE016_HelpParents_Intro (TIME SPENT ON HELPING PARENTS)
  How much time did you spend yesterday on helping your parents or parents-in-law? This can include assistance
  with administrative chores, washing, dressing, taking them to see the doctor etc.

  Please include time spent with step parents and adoptive parents too.
  1. Continue

TE017_HelpParents_Hrs (HOURS SPENT ON HELPING PARENTS)
  Hours:
  NUMBER [0..24]

TE018_HelpParents_Mts (MINUTES SPENT ON HELPING PARENTS)
  Minutes:
  NUMBER [0..59]

CHECK: (NOT((TE017_HelpParents_Hrs = 24 AND (TE018_HelpParents_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
   IF ((NOT(MN002_Person[2].RespId = Empty) OR (Sec_DN1.DN040_PartnerOutsideHH = a1))
   ▣
        TE019_HelpPartner_Intro (TIME SPENT ON HELPING PARTNER)
           How much time did you spend yesterday on helping *[your husband/ your wife/ your partner]*? This can
           include assistance with administrative chores, washing, dressing, taking *[him/ her/ him/her]* to see the
           doctor etc.
           1. Continue

        TE020_HelpPartner_Hrs (HOURS SPENT ON HELPING PARTNER)
          Hours:
          NUMBER [0..24]

        TE021_HelpPartner_Mts (MINUTES SPENT ON HELPING PARTNER)
          Minutes:
          NUMBER [0..59]

        CHECK: (NOT((TE020_HelpPartner_Hrs = 24 AND (TE021_HelpPartner_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
   ENDIF
TE022_HelpOther_Intro (TIME SPENT ON HELPING OTHER FAMILY)
  How much time did you spend yesterday on helping other family members or other people you know? DO
  NOT include helping *[your husband or/ your wife or/ your partner or]* parents and kids that you have
  already mentioned here.

  If necessary repeat: for instance assistance with administrative chores, washing, dressing, taking someone to see
  the doctor, etc.
  1. Continue

TE023_HelpOther_Hrs (HOURS SPENT ON HELPING OTHER FAMILY)
  Hours:
  NUMBER [0..24]

TE024_HelpOther_Mts (MINUTES SPENT ON HELPING OTHER FAMILY)
  Minutes
  NUMBER [0..59]

CHECK: (NOT((TE023_HelpOther_Hrs = 24 AND (TE024_HelpOther_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
TE025_Leisure_Intro (TIME SPENT ON LEISURE)
  How much time did you spend yesterday on leisure time activities?
  This can include watching TV, social media, sports, hobbies, talking with friends or family, going out etc.
  1. Continue

TE026_Leisure_Hrs (TIME SPENT ON LEISURE)
  Hours:
  NUMBER [0..24]

TE027_Leisure_Mts (MINUTES SPENT ON LEISURE)
  Minutes
  NUMBER [0..59]

CHECK: (NOT((TE026_Leisure_Hrs = 24 AND (TE027_Leisure_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
TE031_Admin_Intro (TIME SPENT ON ADMINISTRATION)
  How much time did you spend yesterday on administrative chores and own family finances?

  1. Continue

TE032_Admin_Hrs (HOURS SPENT ON ADMINISTRATION)
  Hours:
  NUMBER [0..24]

TE033_Admin_Mts (MINUTES SPENT ON ADMINISTRATION)
  Minutes:
  NUMBER [0..59]

CHECK: (NOT((TE032_Admin_Hrs = 24 AND (TE033_Admin_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
TE034_PaidWork_Intro (TIME SPENT ON PAID WORK)
  How much time did you spend yesterday on paid work? Paid work can be in employment or as self-employed.

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 124 ---

Please, do NOT include the time spent traveling to and from work, but do count overtime hours.
  1. Continue

**TE035_PaidWork_Hrs** (HOURS SPENT ON PAID WORK)
  Hours
  NUMBER [0..24]

**TE036_PaidWork_Mts** (MINUTES SPENT ON PAID WORK)
  Minutes:
  NUMBER [0..59]

**CHECK**: (NOT((TE035_PaidWork_Hrs = 24 AND (TE036_PaidWork_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
**TE037_VoluntaryWork_Intro** (TIME SPENT ON VOLUNTARY WORK)
  How much time did you spend yesterday on **voluntary work**?
  Please, do NOT include household chores, helping family members, care for children, and other activities you have
  already just mentioned.

  Examples are voluntary work for religious, educational, political, health-related or other charitable organizations
  1. Continue

**TE038_VoluntaryWork_Hrs** (HOURS SPENT ON VOLUNTARY WORK)
  Hours:
  NUMBER [0..24]

**TE039_VoluntaryWork_Mts** (MINUTES SPENT ON VOLUNTARY WORK)
  Minutes:
  NUMBER [0..59]

**CHECK**: (NOT((TE038_VoluntaryWork_Hrs = 24 AND (TE039_VoluntaryWork_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
  *IF ((((TE035_PaidWork_Hrs > 0 OR (TE036_PaidWork_Mts > 0) OR (TE038_VoluntaryWork_Hrs > 0) OR (TE039_VoluntaryWork_Mts > 0))*
    ▣
        **TE040_Travel_Intro** (TIME SPENT ON TRAVEL)
          Continue to think about yesterday, from the morning until the end of the day.
          How much time did you spend yesterday on **traveling** to and from work or voluntary work?
          Enter zero if the respondent did not work on the previous day
          1. Continue

        **TE041_Travel_Hrs** (HOURS SPENT ON TRAVEL)
          Hours:
          NUMBER [0..24]

        **TE042_Travel_Mts** (MINUTES SPENT ON TRAVEL)
          Minutes:
          NUMBER [0..59]

        **CHECK**: (NOT((TE041_Travel_Hrs = 24 AND (TE042_Travel_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
  *ENDIF*
**TE046_Napping_Intro** (TIME SPENT ON NAPPING)
  How much time did you spend yesterday on **napping and resting during daytime**? Do not include sleeping at
  night time.

  1. Continue

**TE047_Napping_Hrs** (HOURS SPENT ON NAPPING)
  Hours:
  NUMBER [0..24]

**TE048_Napping_Mts** (MINUTES SPENT ON NAPPING)
  Minutes:
  NUMBER [0..59]

**CHECK**: (NOT((TE047_Napping_Hrs = 24 AND (TE048_Napping_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
**TE049_Sleeping_Intro** (TIME SPENT ON SLEEPING)
  How much time did you spend yesterday on **sleeping at night time**?

  1. Continue

**TE050_Sleeping_Hrs** (HOURS SPENT ON SLEEPING)
  Hours:
  NUMBER [0..24]

**TE051_Sleeping_Mts** (MINUTES SPENT ON SLEEPING)
  Minutes:
  NUMBER [0..59]

**CHECK**: (NOT((TE050_Sleeping_Hrs = 24 AND (TE051_Sleeping_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
**TE052_OtherActivities** (DID SPEND TIME ON OTHER ACTIVITIES)
  Did you spend time yesterday on **other activities** which we have not asked about yet?
  1. Yes
  5. No

  *IF (TE052_OtherActivities = 1)*
    ▣
        **TE053_WhatActivities** (OTHER ACTIVITIES SPEND TIME ON)
          What other activity was that or what other activities were those?
          STRING

        **TE054_TimeOtherActivities_Intro** (TIME SPENT ON OTHER ACTIVITIES)
          How much time did you spend yesterday on this activity or these activities?

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 125 ---

If more than one other activity was mentioned, sum up the time spent on each of these other activities.
            1. Continue

            **TE055_TimeOtherActivities_Hrs** (HOURS SPENT ON OTHER ACTIVITIES)
              Hours:
              NUMBER [0..24]

            **TE056_TimeOtherActivities_Mts** (MINUTES SPENT ON OTHER ACTIVITIES)
              Minutes:
              NUMBER [0..59]

            **CHECK**: (NOT((TE055_TimeOtherActivities_Hrs = 24 AND (TE056_TimeOtherActivities_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
          *ENDIF*
          IF (((NOT(MN002_Person[2].RespId = Empty) OR (Sec_DN1.DN040_PartnerOutsideHH = a1) AND
        ((TE026_Leisure_Hrs > 0 OR (TE027_Leisure_Mts > 0)))
        ⊟
            **TE057_PartnerActivities_Intro** (TIME SPENT WITH PARTNER)
              You mentioned that you spent ^FL_TE057_3; hours and ^FL_TE057_4; minutes on leisure time activities,
              yesterday. How much of that time did you spend together with *[your husband/ your wife/ your partner]*?

              If respondent did not spend any time on leisure activities together with *[husband/ wife/ partner]*, enter 0
              1. Continue

            **TE058_PartnerActivities_Hrs** (HOURS SPENT WITH PARTNER)
              Hours:
              NUMBER [0..24]

            **TE059_PartnerActivities_Mts** (MINUTES SPENT WITH PARTNER)
              Minutes:
              NUMBER [0..59]

            **CHECK**: ( *(60, TE058_PartnerActivities_Hrs)TE059_PartnerActivities_Mts <= *(60,
            TE026_Leisure_Hrs)TE027_Leisure_Mts) *[You cannot spend more time on leisure activities with your partner than the overall time spent on leisure.;]*
            **CHECK**: (NOT((TE058_PartnerActivities_Hrs = 24 AND (TE059_PartnerActivities_Mts > 0))) *[Are you sure? Value seems unlikely.;]*
          *ENDIF*
        **TE060_IntCheck** (INTERVIEWER CHECK TE)

          CHECK:
          Who answered the questions in this section?
          1. Respondent only
          2. Respondent and proxy
          3. Proxy only

        *ENDIF*
      *ENDIF*
*ENDIF*
*IF (((EX IN (Test) OR ((ALL IN (Test))))*
⊟
    **EX601_NonProxy** (INTRO EX_PROXY)

      Start of a **Non-proxy section**. No proxy allowed. If the respondent is not present or not capable to give consent to participation on her/his own, press **CTRL-K** at each question.
      1. Continue

      *IF (MN101_Longitudinal = 0)*
      ⊟
          **EX029_FreqPrayer** (PRAYING)
          Now, I have a question about praying. These days, how often do you pray?
          Read out.;
          1. More than once a day
          2. Once daily
          3. A couple of times a week
          4. Once a week
          5. Less than once a week
          6. Never

      *ENDIF*
      **EX001_Introtxt** (INTRODUCTION AND EXAMPLE)
      Now, I have questions about how likely you think various events might be. When I ask a question I'd like for you to give me a number from 0 to 100.

      Let's try an example together and start with the weather. Looking at card 45, what do you think the chances are that it will be sunny tomorrow? For example, '90' would mean a 90 per cent chance of sunny weather. You can say any number from 0 to 100.
      NUMBER [0..100]

      *IF (MN101_Longitudinal = 0)*
      ⊟
          *IF (Sec_EP.EP005_CurrentJobSit = a2)*
          ⊟
              **EX007_GovRedPens** (GOVERNMENT REDUCES PENSION)
              (Please look at card 45).
              What are the chances that before you retire the government will reduce the pension which you are entitled to?
              NUMBER [0..100]

              *IF (MN808_AgeRespondent < 61)*
              ⊟
                  **EX025_ChWrkA65** (CHANCE TO WORK AFTER AGE OF 63)

--- page 126 ---

(Please look at card 45).
                        Thinking about your work generally and not just your present job, what are the chances that you will be
                        working full-time after you reach age 63?
                        NUMBER [0..100]

                    ENDIF
                    EX008_GovRaisAge (GOVERNMENT RAISES RETIREMENT AGE)
                        (Please look at card 45).
                        What are the chances that before you retire the government will raise your retirement age?
                        NUMBER [0..100]

            ENDIF
        ENDIF
        IF (MN808_AgeRespondent < 101)
        ⊟
            EX009_LivTenYrs (LIVING IN TEN YEARS)
                (Please look at card 45).
                What are the chances that you will live to be age [75/80/85/90/95/100/105/110/120] or more?
                NUMBER [0..100]

        ENDIF
        IF (MN101_Longitudinal = 0)
        ⊟
            EX026_Trust (TRUST IN OTHER PEOPLE)
                Now I would like to ask a question about how you view other people. Generally speaking, would you say that most people
                can be trusted or that you can't be too careful in dealing with people? Not looking at card 45 anymore, please tell me on a
                scale from 0 to 10, where 0 means you can't be too careful and 10 means that most people can be trusted.
                NUMBER [0..10]

            EX110_RiskAv (RISK AVERSION)
                Please look at card 46. When people invest their savings they can choose between assets that give low return with little
                risk to lose money, for instance a bank account or a safe bond, or assets with a high return but also a higher risk of losing
                money, for instance stocks and shares. Which of the statements on the card comes closest to the amount of financial risk
                that you are willing to take when you save or make investments?
                Read answers only if necessary. If more than one response is given use the first category that applies.
                1. Take substantial financial risks expecting to earn substantial returns
                2. Take above average financial risks expecting to earn above average returns
                3. Take average financial risks expecting to earn average returns
                4. Not willing to take any financial risks

            EX111_XYZ_Planning_Horizon (PLANNING HORIZON)
                In planning your saving and spending, which of the following time periods is most important to you?
                Read out.;
                The option 'next few months' includes also 'next few days' and 'next few weeks'
                1. Next few months
                2. Next year
                3. Next few years
                4. Next 5-10 years
                5. Longer than 10 years

        ENDIF
        IF (MN101_Longitudinal = 0)
        ⊟
            IF (MN005_ModeQues = a2)
            ⊟
                EX800_PartInterv (PARTNER PARTICIPATES AFTERWARDS)

                    Will the partner be (proxy) interviewed right afterwards?
                    Please note: Proxy interviews are only allowed in case of hearing loss, speaking problems, or difficulties in
                    concentrating.
                    1. Yes
                    5. No

                    IF (EX800_PartInterv = a5)
                    ⊟
                        EX101_IntroPartInfo (INTRODUCTION PARTNER INFORMATION)
                            Before we finish, could you please also give me some information on[your][husband/ wife/ partner], who is
                            not doing the interview today?
                            1. Continue

                        EX602_PartYrsEduc (PARTNER YEARS OF EDUCATION)
                            How many years has[your][husband/ wife/ partner] been in school all together?
                            "in school" means in "full-time education", that;
                            * includes: receiving tuition, engaging in practical work or supervised study or taking examinations
                            * excludes: full-time working, home schooling, distance learning, special on-the-job training, evening
                            classes, part-time private vocational training, flexible or part-time higher education studies, etc
                            NUMBER [0..999]

                        EX603_PartJobSit (PARTNER CURRENT JOB SITUATION)
                            Please look at card 47.
                            In general, how would you describe the current employment situation of[your][husband/ wife/ partner]?
                            Read out.;
                            1. Retired
                            2. Employed or self-employed (including working for family business)
                            3. Unemployed
                            4. Permanently sick or disabled
                            5. Homemaker
                            97. Other

                            IF (EX603_PartJobSit = a2)
                            ⊟
                            |

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 127 ---

EX613_LastJobPartner (NAME OR TITLE OF JOB PARTNER)
            What is the most recent job[your][husband/ wife/ partner]^FL_EX613_3; had?
            STRING

              IF (NOT(EX613_LastJobPartner = Refusal))
              ⊟
                  EX613c_LastJobPartnerCode (JOBCODER - NAME OR TITLE OF JOB PARTNER)
                      I will now search for this job title among official jobs titles in our database.
                      Re-type the job title and select the best matching job from the drop-down list. Please, check
                      for spelling mistakes. If you navigate or scroll down, you will find more job titles.
                      If you don't find the job title, ask the R to think of a different name for the job or to give a
                      broader or a more specific job description.
                      If you cannot find any good match at all, type 991.
                      STRING

                      JOBCODER: InDataOccupations
                        IF ((NOT(EX613c_LastJobPartnerCode = Empty) AND (NOT(EX613c_LastJobPartnerCode =
                        991)))
                        ⊟
                            EX613d_LastJobPartnerCode (JOBCODER - NEXT)

                              Please verify that you selected the correct job title:
                              ^EX613c_LastJobPartnerCode;
                              If this is not the correct job title, go back select the best matching one from the drop-
                              down list.
                              1. Confirm and continue

                        ENDIF
                      ENDIF
              ENDIF
              IF ((EX603_PartJobSit <> a1 AND (EX603_PartJobSit <> a2))
              ⊟
                  EX104_PartEvWork (PARTNER EVER DONE PAID WORK)
                      Has[your][husband/ wife/ partner] ever done any paid work?
                      1. Yes
                      5. No

              ENDIF
              IF (((EX603_PartJobSit = a1 OR (EX603_PartJobSit = a2) OR (EX104_PartEvWork = a1))
              ⊟
                  EX105_PartEmp (PARTNER EMPLOYEE OR A SELF-EMPLOYED)
                      In[his/ her][last/ current] job,[was/ is][your][husband/ wife/ partner] a private sector employee, a
                      public sector employee or a self-employed?
                      1. Private sector employee
                      2. Public sector employee
                      3. Self-employed

              ENDIF
        ENDIF
      ENDIF
    ENDIF
EX023_Outro (NON PROXY)

    CHECK: Who answered the questions in this section?
    1. Respondent
    2. Section not answered (proxy interview)

    IF (MN040_ex123consent = 1)
    ⊟
        EX123_Consent (CONSENT TO RECONTACT)
            In order to study how people´s lives change when they get older, it is important to interview the same people about
            every two years. For this reason, we hope that it is ok with you that we keep your name and address in our files so that
            we can contact you again. Is this ok?
            Let respondent sign consent statement. If the respondent asks or hesitates, say that he/she can still say no at the time
            when recontacting.
            1. Consent to recontact
            5. No consent to recontact

    ENDIF
    IF (MN042_ex106do = 1)
    ⊟
        EX106_HandOutA (HAND OUT DROP-OFF QUESTIONNAIRE)

            Take a drop-off questionnaire and fill in first name and respondent id ^RespondentID; on the drop-off cover.
            Enter drop-off serial number from drop-off questionnaire to CAPI below.
            Hand out drop-off questionnaire to respondent.
            STRING

    ENDIF
EX024_Outro2 (THANK YOU FOR PARTICIPATION)
    Thank you. This was the last question. We would like to thank you very much again for participating in the survey. We know it
    has been a long and difficult questionnaire, but your help was really important. With your participation you have helped
    researchers to understand how the ageing of populations in Europe affects our future.
    1. Continue

  ENDIF
  IF (((IV IN (Test) OR ((ALL IN (Test)))
  ⊟
      IV001_Intro (INTRODUCTION TO IV)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 128 ---

THIS SECTION IS ABOUT YOUR OBSERVATIONS DURING THE INTERVIEW AND SHOULD BE FILLED OUT AFTER EACH COMPLETED INDIVIDUAL INTERVIEW.
   1. Continue

   IF (((((((((((((((((((((Sec_DN1.DN038_IntCheck = a2 OR (Sec_DN1.DN038_IntCheck = a3) OR (Sec_PH.PH054_IntCheck =
a2) OR (Sec_PH.PH054_IntCheck = a3) OR (Sec_BR.BR017_IntCheck = a2) OR (Sec_BR.BR017_IntCheck = a3) OR
(Sec_EP.EP210_IntCheck = a2) OR (Sec_EP.EP210_IntCheck = a3) OR (Sec_CH.CH023_IntCheck = a2) OR
(Sec_CH.CH023_IntCheck = a3) OR (Sec_SP.SP022_IntCheck = a2) OR (Sec_SP.SP022_IntCheck = a3) OR
(Sec_FT.FT021_IntCheck = a2) OR (Sec_FT.FT021_IntCheck = a3) OR (Sec_HO.HO041_IntCheck = a2) OR
(Sec_HO.HO041_IntCheck = a3) OR (Sec_HH.HH014_IntCheck = a2) OR (Sec_HH.HH014_IntCheck = a3) OR
(Sec_CO.CO009_IntCheck = a2) OR (Sec_CO.CO009_IntCheck = a3) OR (Sec_AS.AS057_IntCheck = a2) OR
(Sec_AS.AS057_IntCheck = a3))
   ⊟
      |IV020_RelProxy (RELATIONSHIP PROXY)
         A proxy respondent has answered some or all of the questions we had for ^FLRespondentName;. How is the proxy
         respondent related to ^FLRespondentName;?
         1. Spouse/Partner
         2. Child/child-in-law
         3. Parent/ Parent-in-law
         4. Sibling
         5. Grand-child
         6. Other relative
         7. Nursing home staff
         8. Home helper
         9. Friend/acquaintance
         10. Other

   ENDIF
IV002_PersPresent (THIRD PERSONS PRESENT)
  Were any third persons, except proxy respondent, present during (parts of) the interview with ^FLRespondentName;?
  Code all that apply.;
  1. Nobody
  2. Spouse or partner
  3. Parent or parents
  4. Child or children
  5. Other relatives
  6. Other persons present

CHECK: (NOT((count(IV002_PersPresent) > 1 AND ((1 IN (IV002_PersPresent)))) [You cannot select 'Nobody' together with any
other answer. Please change your answer.;]
   IF (NOT(((a1 IN (IV002_PersPresent) AND (count(IV002_PersPresent) = 1)))
   ⊟
      |IV003_PersIntervened (INTERVENED IN INTERVIEW)
         Have these persons intervened in the interview?
         1. Yes, often
         2. Yes, occasionally
         3. No

   ENDIF
IV004_WillingAnswer (WILLINGNESS TO ANSWER)
  How would you describe the willingness of ^FLRespondentName; to answer?
  1. Very good
  2. Good
  3. Fair
  4. Bad
  5. Good in the beginning, got worse during the interview
  6. Bad in the beginning, got better during the interview

   IF (IV004_WillingAnswer = a5)
   ⊟
      |IV005_WillingnessWorse (WHY WILLINGNESS WORSE)
         Why did the respondent's willingness to answer get worse during the interview?
         Code all that apply.;
         1. The respondent was losing interest
         2. The respondent was losing concentration or was getting tired
         3. Other, please specify

         IF ((a3 IN (IV005_WillingnessWorse))
         ⊟
               |IV006_OthReason (WHICH OTHER REASON)
                  Which other reason?
                  STRING

            ENDIF
   ENDIF
IV007_AskClarification (RESP. ASK FOR CLARIFICATION)
  Did ^FLRespondentName; ask for clarification on any questions?
  1. Never
  2. Almost never
  3. Now and then
  4. Often
  5. Very often
  6. Always

IV008_RespUnderstoodQst (RESPONDENT UNDERSTOOD QUESTIONS)
  Overall, did you feel that ^FLRespondentName; understood the questions?
  1. Never
  2. Almost never
  3. Now and then
  4. Often
  5. Very often
  6. Always

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 129 ---

IV018_HelpShowcards (HELP NEEDED READING SHOWCARDS)
   Did the respondent need any help reading the showcards during the interview?
   1. Yes, due to sight problems
   2. Yes, due to literacy problems
   3. No

   IF (MN008_NumHHR = 1)
   ⊟
         IF ((Sec_HO.HO001_Place = a1 OR (MN024_NursingHome = a2))
         ⊟
               IV009_AreaLocationBldg (WHICH AREA BUILDING LOCATED)
                  In which type of area is the building located?
                  1. A big city
                  2. The suburbs or outskirts of a big city
                  3. A large town
                  4. A small town
                  5. A rural area or village

               IV610_TypeBuilding (TYPE OF BUILDING)
                  Which type of building does the household live in?
                  A nursing home provides all of the following services for its residents: dispensing of medication, available, 24-hour personal assistance and supervision (not necessarily a nurse), and room & meals
                  1. A farm house
                  2. A free standing one or two family house
                  3. A one or two family house as row or double house
                  4. A building with 3 to 8 flats
                  5. A building with 9 or more flats but no more than 8 floors
                  6. A high-rise with 9 or more floors
                  7. A housing complex with services for older people (residential home or sheltered housing, but not a nursing home)
                  8. A nursing home

                  IF ((IV610_TypeBuilding = a7 OR (IV610_TypeBuilding = a8))
                  ⊟
                        IV621_Certifiednurse (At LEAST A NURSE)
                           Is there at least one (certified) nurse in the assistance or supervision staff?
                           1. Yes
                           5. No

                  ENDIF
               IV012_StepstoEntrance (NUMBER OF STEPS TO ENTRANCE)
                  How many steps had to be climbed (up or down) to get to the main entrance of the household's flat?
                  Do not include steps that are avoided, because the block has an elevator
                  1. Up to 5
                  2. 6 to 15
                  3. 16 to 25
                  4. More than 25

         ENDIF
      ENDIF
      IV019_InterviewerID (INTERVIEWER ID)
         Your interviewer ID:
         STRING

      CHECK: (NOT((IV019_InterviewerID = OR (NOT(IV019_InterviewerID = RESPONSE)))) [Please enter a value;]
      IV017_Outro (OUTRA IV)
         Thank you very much for completing this section.
         1. Continue

   ENDIF
ENDIF
ELSE
⊟
   IF (XT_Active = 1)
   ⊟
      XT104_SexDec (SEX OF DECEDENT)

         Note sex of decedent (ask if unsure)
         1. Male
         2. Female

      XT001_Intro (INTRODUCTION TO EXIT INTERVIEW)
         {{Name of the deceased}} has participated in the SHARE study before{his/ her} death.{His/ Her} contribution was very valuable. We would find it extremely helpful to have some information about the final year of{{Name of the deceased}}'s life. All the information collected is strictly confidential, and will be held anonymously.
         1. Continue

      XT006_ProxSex (PROXY RESPONDENT'S SEX)

         Code proxy respondent's sex.
         1. Male
         2. Female

      XT002_Relation (RELATIONSHIP TO THE DECEASED)
         Before we start asking questions about the last year of life of{{Name of the deceased}}, would you please tell me what was your relationship to the deceased?
         If unclear, specify: "So you were {his/ her}..."
         1. Husband or wife or partner
         2. Son or Daughter
         3. Son- or Daughter-in-law
         4. Son or Daughter of husband, wife or partner

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 130 ---

5. Grandchild
6. Sibling
7. Other relative (specify)
8. Other non-relative (specify)

 IF (XT002_Relation = a7)
 ⊟
     XT003_OthRel (OTHER RELATIVE)

       Specify other relative
       STRING

 ENDIF
 IF (XT002_Relation = a8)
 ⊟
     XT004_OthNonRel (OTHER NO-RELATIVE)

       Specify other non-relative
       STRING

 ENDIF
XT005_HowOftCont (HOW OFTEN CONTACT LAST TWELVE MONTHS)
 During the last twelve months of[his/ her] life, how often did you have contact with[{Name of the deceased}], either in person, by
 phone, mail, email, or any other electronic means?
 1. Daily
 2. Several times a week
 3. About once a week
 4. About every two weeks
 5. About once a month
 6. Less than once a month
 7. Never

 IF (XT002_Relation <> a1)
 ⊟
     XT007_YearBirth (YEAR OF BIRTH PROXY)
       Can you tell me your year of birth?
       NUMBER [1900..2012]

 ENDIF
XT101_ConfDecYrBirth (CONFIRMATION DECEASED YEAR OF BIRTH)
 Let us now talk about the deceased. Just to make sure that we have the correct information about[{Name of the deceased}], can I just
 confirm that[he/ she] was born in[{Month and Year birth of deceased}]?
 1. Yes
 5. No

 IF (XT101_ConfDecYrBirth = a5)
 ⊟
     XT802_IntroDecBirth (DECEASED INTRO BIRTH)
       In which month and year was[{Name of the deceased}] born?
       1. Continue

     XT102_DecMonthBirth (DECEASED MONTH OF BIRTH)
       Month:
       1. January
       2. February
       3. March
       4. April
       5. May
       6. June
       7. July
       8. August
       9. September
       10. October
       11. November
       12. December

     XT103_DecYearBirth (DECEASED YEAR OF BIRTH)
       Year:
       NUMBER [1900..2010]

 ENDIF
XT008_MonthDied (MONTH OF DECEASE)
 We would like to know more about the circumstances of[{Name of the deceased}] 's death. In what month and year did[he/ she] pass
 away?

 MONTH:
 YEAR:
 Month
 1. January
 2. February
 3. March
 4. April
 5. May
 6. June
 7. July
 8. August
 9. September
 10. October
 11. November
 12. December

XT009_YearDied (YEAR OF DECEASE)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 131 ---

In what month and **YEAR** did*[he/ she]* pass away?
_
MONTH: ^XT008_MonthDied;
**YEAR**:
Year
1. 2006
2. 2007
3. 2008
4. 2009
5. 2010
6. 2011
7. 2012
8. 2013
9. 2014
10. 2015
11. 2016
12. 2017
13. 2018
14. 2019
15. 2020
16. 2021
17. 2022
18. 2023
19. 2024

**XT010_AgeDied** (AGE AT THE MOMENT OF DECEASE)
  How old was*[{Name of the deceased}]* when*[he/ she]* passed away?
  Age in years
  NUMBER [20..120]

**XT109_DecMarried** (DECEASED MARRIED AT TIME OF DEATH)
  Was*[?Name of the deceased}]* married at the time of*[his/ her]* death?
  1. Yes
  5. No

**XT039_NumChild** (NUMBER OF CHILDREN THE DECEASED HAD AT THE END)
  How many children did*[{Name of the deceased}]* have that were still alive at the time of*[his/ her]* death? Please count all natural children, fostered, adopted and stepchildren
  NUMBER [0..999]

**XT011_CauseDeath** (THE MAIN CAUSE OF DEATH)
  What was the main cause of*[his/ her]* death?
  Read out if necessary
  Note: Covid-19 or related complications have their own response option (9).
  1. Cancer
  2. A heart attack
  3. A stroke
  4. Other cardiovascular related illness such as heart failure, arrhythmia
  5. Respiratory disease
  6. Disease of the digestive system such as gastrointestinal ulcer, inflammatory bowel disease
  7. Severe infectious disease such as pneumonia, septicemia or flu
  8. Accident or suicide
  9. Covid-19 or related complications
  97. Other (Please specify)

  *IF (XT011_CauseDeath = a97)*
  ⊟
      **XT012_OthCauseDeath** (OTHER CAUSE OF DEATH)

        Specify other cause of death
        STRING

  *ENDIF*
**XT013_HowLongIll** (HOW LONG BEEN ILL BEFORE DECEASE)
  How long had*[{Name of the deceased}]* been ill before*[he/ she]* died?
  Read out.;
  1. Less than one month
  2. One month or more but less than 6 months
  3. 6 months or more but less than a year
  4. One year or more
  5. (spontaneous) Was not ill before*[he/ she]* died

**XT014_WhereDied** (PLACE OF DYING)
  Did*[he/ she]* die ...
  Read out.;
  By 'hospice' we mean a specific palliative care facility for terminally ill or seriously ill patients.
  1. At*[his/ her]* own home
  2. At another person's home
  3. In a hospital
  4. In a nursing home
  5. In a residential home, sheltered housing, or old people's home
  6. In a hospice
  7. In transit to a medical facility
  97. At some other place

  *IF (XT014_WhereDied = a97)*
  ⊟
      **XT060_OthWhereDied** (OTHER PLACE OF DEATH)
        Specify other place of death.
        STRING

  *ENDIF*
  *IF ((XT014_WhereDied = a1 AND (XT009_YearDied > a14))*

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 132 ---

XT123_CADieAlone (ANYONE ELSE PRESENT)
         Was there anyone else present when*{Name of the deceased}* passed away?
         1. Yes
         5. No

         IF (XT123_CADieAlone = a5)
         
               XT124_CAWhyAlone (DIED ALONE DUE TO CORONA)
                    Was this due to the outbreak of corona?
                    1. Yes
                    2. Partly
                    5. No

               ENDIF
      ENDIF
      IF (XT014_WhereDied = a3)
      
            XT750_ICU (IN INTENSIVE CARE UNIT)
               Was that in the Intensive Care Unit?
               1. Yes
               5. No

      ENDIF
      IF (((XT750_ICU = a5 OR (XT014_WhereDied = a4) OR (XT014_WhereDied = a5))
      
            XT751_palcareinpoatienthospice (PALLIATIVE CARE OR INPATIENT HOSPICE)
               Was that in a palliative care or inpatient hospice unit?
               By "hospice" we mean a specific palliative care facility for terminally ill or seriously ill patients.
               1. Yes
               5. No

      ENDIF
      IF ((XT014_WhereDied = a4 OR (XT014_WhereDied = a5))
      
            XT767_Certifiednurse (At LEAST A NURSE)
               Was there at least one (certified) nurse in the assistance or supervision staff?
               1. Yes
               5. No

      ENDIF
XT615_TimesInHosp (TIMES IN HOSPITAL LAST YEAR BEFORE DYING)
   In the last year before*{he/ she}* died, on how many different occasions did*{Name of the deceased}* stay in a hospital, hospice or nursing home?
   Please count here only the separate occasions where*{he/ she}* has been in such facilities, and not the total number of days spent in hospital, hospice, or nursing home.
   NUMBER [0..999]

   IF (XT615_TimesInHosp > 0)
   
         XT016_TotalTimeHosp (TOTAL TIME IN HOSPITAL LAST YEAR BEFORE DYING)
            During the last year of*{his/ her}* life, for how long altogether did*{Name of the deceased}* stay at hospitals, hospices or nursing homes?
            Do not read out
            1. Less than one week
            2. One week or more but less than one month
            3. One month or more but less than 3 months
            4. 3 months or more but less than 6 months
            5. 6 months or more but less than a year
            6. A full year

   ENDIF
   IF (XT009_YearDied > a14)
   
         XT125_CANotInHosp (COULD NOT STAY IN HOSPITAL DUE TO CORONA)
            In the last year before*{he/ she}* died, did*{Name of the deceased}* ever need to stay in a hospital, hospice or nursing home and could not because of the outbreak of corona?
            1. Yes
            5. No

         XT126_CAFearInf (FORGO TREATMENT DUE TO FEAR INFECTION)
            In the last year before*{he/ she}* died, did*{Name of the deceased}* forgo any medical treatment or operation, because*{he/ she}* was afraid to become infected by the coronavirus?
            1. Yes
            5. No

   ENDIF
XT756_IntroCare (CARE INTRO)
   The next couple of questions are about the care *{Name of the deceased}* received in the last month of *{his/ her}* life. Please answer these questions based on your experience and the deceased's experience while *{he/ she}* was receiving care.
   1. Continue

   IF (NOT((XT014_WhereDied = a6 OR (XT751_palcareinpoatienthospice = a1)))
   
         XT757_hospiceorpalliativecare (HOSPICE OR PALLIATIVE CARE)
            In the last four weeks of *{his/ her}* life, did *{Name of the deceased}* have any hospice or palliative care?
            By "hospice" we mean a specific palliative care facility for terminally ill or seriously ill patients.
            1. Yes
            5. No

            IF (XT757_hospiceorpalliativecare = a5)

--- page 133 ---

XT754_reasonnocare (REASON NOT HOSPICE)
                    What was the reason that *[he/ she]* did not have hospice or palliative care?
                    Read out.;
                    1. Was not needed or wanted
                    2. Was needed or wanted but not available
                    3. Was needed or wanted but too expensive

                    IF (XT009_YearDied > a14)

                        XT127_CAnocare (NO HOSPICE DUE TO CORONA)
                            Was this due to the outbreak of corona?
                            1. Yes
                            2. Partly
                            5. No

                    ENDIF
                ENDIF
        ENDIF
XT758_medicinepain (MEDICINE FOR PAIN)
    In *[his/ her]* last month of life, did *[{Name of the deceased}]* have pain or take medicine for pain?
    1. Yes
    5. No

    IF (XT758_medicinepain = a1)

        XT759_medicineamount (MEDICATION AMOUNT)
            Did the deceased receive too much, too little, or just the right amount of medication for *[his/ her]* pain?
            1. Too much
            2. Too little
            3. Right amount

            IF ((XT759_medicineamount = a2 AND (XT009_YearDied > a14))

                XT128_CAreasonmedicineamount (TOO LITTLE MEDICATION DUE TO CORONA)
                    Was this due to the outbreak of corona?
                    1. Yes
                    2. Partly
                    5. No

            ENDIF
    ENDIF
XT760_troublebreathing (TROUBLE BREATHING)
    In *[his/ her]* last month of life, did *[{Name of the deceased}]* have trouble breathing?
    1. Yes
    5. No

    IF (XT760_troublebreathing = a1)

        XT761_helpbreathing (HOW MUCH HELP BREATHING)
            How much help in dealing with *[his/ her]* breathing did the deceased receive - too little, or just the right amount?
            1. Too little
            2. Right amount

            IF ((XT761_helpbreathing = a1 AND (XT009_YearDied > a14))

                XT129_CAreasonhelpbreathing (TOO LITTLE HELP BREATHING DUE TO CORONA)
                    Was this due to the outbreak of corona?
                    1. Yes
                    2. Partly
                    5. No

            ENDIF
    ENDIF
XT762_anxietysadness (ANXIETY SADNESS)
    In *[his/ her]* last month of life, did *[{Name of the deceased}]* have any feelings of anxiety or sadness?
    1. Yes
    5. No

    IF (XT762_anxietysadness = a1)

        XT763_helpanxietysadness (HOW MUCH HELP ANXIETY OR SADNESS)
            How much help in dealing with these feelings did the deceased receive - too little, or just the right amount?
            1. Too little
            2. Right amount

    ENDIF
XT764_personalcare (PERSONAL CARE NEEDS MET)
    How often were the deceased's personal care needs - such as bathing, dressing, and changing bedding - taken care of as well as they
    should have been?
    Read out.;.
    1. Always
    2. Usually
    3. Sometimes
    4. Never
    5. Help was not needed or wanted for personal care

    IF ((((XT764_personalcare = a3 OR (XT764_personalcare = a4) OR (XT764_personalcare = a5) AND (XT009_YearDied > a14))

        XT130_CAreasonpersonalcare (TOO LITTLE PERSONAL CARE DUE TO CORONA)

--- page 134 ---

Was this due to the outbreak of corona?
            1. Yes
            2. Partly
            5. No

   ENDIF
XT765_staff (STAFF CARING AND RESPECTFULL)
  During *[his/ her]* last month of life, how often overall was the staff who took care of *[him/ her]* kind, caring, and respectful? By staff,
  we mean all professional staff who are paid (by someone) for their services. This includes doctors, nurses, social workers, chaplains,
  nursing assistants, therapists, and other personnel.
  Read out.;.
  1. Always
  2. Usually
  3. Sometimes
  4. Never
  5. There was no staff (paid professional) who took care

   IF ((XT765_staff = a5 AND (XT009_YearDied > a14))
   -
        XT131_CAreasonnostaff (NO STAFF DUE TO CORONA)
            Was this due to the outbreak of corona?
            1. Yes
            2. Partly
            5. No

   ENDIF
   IF (XT765_staff <> a5)
   -
        XT766_ratecare (RATE CARE)
            Overall, how would you rate the care the deceased received by the staff in *[his/ her]* last month of life?
            Read out.;.
            1. Excellent
            2. Very good
            3. Good
            4. Fair
            5. Poor

             IF (XT009_YearDied > a14)
             -
                  XT132_CAqualitycare (QUALITY CARE AFFECTED BY CORONA)
                      To what extent do you think the quality of care for*[{Name of the deceased}]* was affected by the outbreak of corona?
                      1. A lot
                      2. Somewhat
                      3. Not at all

                  ENDIF
        ENDIF
XT017_IntroMedCare (INTRODUCTION EXPENSES MEDICAL CARE)
We would now like to ask you some questions about any expenses which*[{Name of the deceased}]* incurred as a result of the medical
care*[he/ she]* received in the last 12 months before*[he/ she]* died.
For each of the types of care I will now list, please indicate whether*[{Name of the deceased}]* received the care and, if so, give your
best estimate of the costs incurred from that care.
Please include only costs not paid or reimbursed by the health insurance or the employer.
1. Continue

 LOOP cnt := 1 TO 9
 -
        IF (((((((cnt < 3 OR (cnt > 5) OR (XT615_TimesInHosp > 0) OR (XT014_WhereDied = a3) OR (XT014_WhereDied = a4) OR
       (XT014_WhereDied = a5))
       -
            XT018_TypeMedCare (HAD TYPE OF MEDICAL CARE IN THE LAST TWELVE MONTHS)
                Did *[{Name of the deceased}]* have any *[care from a general practitioner/ care from specialist physicians/ hospital stays/*
                *care in a nursing home/ hospice stays/ medication/ aids and appliances such as wheelchairs, rollators, walking sticks and*
                *crutches, orthoses, or protheses/ help with personal care due to disability/ help with domestic tasks due to disability]* (in
                the last 12 months of*[his/ her]* life)?
                *[Help \"with personal care due to disability\" refers here to professional help/care/assistance received at home (not in a*
                *healthcare facility)./ Help \"with domestic tasks due to disability\" refers here to professional help/care/assistance*
                *received at home (not in a healthcare facility).]*
                1. Yes
                5. No

                 IF (XT018_TypeMedCare = a1)
                 -
                      XT119_CostsMedCare (COSTS OF TYPE OF MEDICAL CARE IN THE LAST TWELVE MONTHS)
                          About how much did *[he/ she]* pay out of pocket for *[care from a general practitioner/ care from specialist*
                          *physicians/ hospital stays/ care in a nursing home/ hospice stays/ medication/ aids and appliances/ help with*
                          *personal care due to disability/ help with domestic tasks due to disability]* (in the last 12 months of *[his/ her]* life)?
                          *[By out of pocket we mean that the costs were not covered or reimbursed by the health insurance/national health*
                          *system/third party.]* ^FL_XT119_5;
                          Fill in '0' if all the expenses were covered or reimbursed. Otherwise fill in the amount in ^FLCurr;
                          |NUMBER [0..100000000000000000]

                           IF (XT119_CostsMedCare = NONRESPONSE)
                           -
                                IF (piIndex = 1)
                                -
                                     |[Unfolding Bracket Sequence]
                                ELSE
                                -
                                     |   IF (piIndex = 2)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 135 ---

|[Unfolding Bracket Sequence]
            ELSE
            IF (piIndex = 3)
                |[Unfolding Bracket Sequence]
                ELSE
                IF (piIndex = 4)
                    |[Unfolding Bracket Sequence]
                    ELSE
                    IF (piIndex = 5)
                        |[Unfolding Bracket Sequence]
                        ELSE
                        IF (piIndex = 6)
                            |[Unfolding Bracket Sequence]
                            ELSE
                            IF (piIndex = 7)
                                |[Unfolding Bracket Sequence]
                                ELSE
                                IF (piIndex = 8)
                                    |[Unfolding Bracket Sequence]
                                    ELSE
                                    |[Unfolding Bracket Sequence]
                                ENDIF
                            ENDIF
                        ENDIF
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
    ENDIF
    [cnt]
ENDIF
ENDLOOP
XT105_DiffWhere (DIFFICULTIES REMEMBERING WHERE)
  We would like to know more about the difficulties people have in their last year of life because of physical, mental, emotional or
  memory problems. During the last year of{his/ her} life, did{Name of the deceased}} have any difficulty remembering where{he/
  she} was? Please name only difficulties that lasted at least three months.
  1. Yes
  5. No

XT106_DiffYear (DIFFICULTIES REMEMBERING THE YEAR)
  During the last year of{his/ her} life, did{Name of the deceased}} have any difficulty remembering what year it was? Please name
  only difficulties that lasted at least three months.
  1. Yes
  5. No

XT107_DiffRecogn (DIFFICULTIES RECOGNIZING)
  During the last year of{his/ her} life, did{Name of the deceased}} have any difficulty recognizing family members or good friends?
  Please name only difficulties that lasted at least three months.
  1. Yes
  5. No

XT020_IntroDiffADL (INTRODUCTION DIFFICULTIES DOING ACTIVITIES)
  Because of a physical, mental, emotional or memory problem, did{Name of the deceased}} have difficulty doing any of the following
  activities during the last twelve months of{his/ her} life? Please name only difficulties that lasted at least three months.
  Read out.;
  Code all that apply.;
  1. Dressing, including putting on shoes and socks
  2. Walking across a room
  3. Bathing or showering
  4. Eating, such as cutting up your food
  5. Getting in or out of bed
  6. Using the toilet, including getting up or down
  96. None of these

CHECK: (NOT((count(XT020_IntroDiffADL) > 1 AND (96 IN (XT020_IntroDiffADL)))) [You cannot select '96' together with any other answer. Please change your answer.;]
XT620_IntroDiffADLII (INTRODUCTION DIFFICULTIES)
  Here is another list of activities. Because of a physical, mental, emotional or memory problem, did {{Name of the deceased}} have
  difficulty doing any of the following activities during the last twelve months of {his/ her} life?
  Please name only difficulties that lasted at least three months.

--- page 136 ---

Read out.;.
Code all that apply.;
1. Preparing a hot meal
2. Shopping for groceries
3. Making telephone calls
4. Taking medication
5. Using a map to figure out how to get around in a strange place
6. Doing work around the house or garden
7. Managing money, such as paying bills and keeping track of expenses
8. Leaving the house independently and accessing transportation services
9. Doing personal laundry
10. Continence over urination or defecation
96. None of these

CHECK: (NOT((count(XT620_IntroDiffADLII) > 1 AND ((96 IN (XT620_IntroDiffADLII)))) *[You cannot select '96' together with any other answer. Please change your answer.;]*
   IF (((count(XT020_IntroDiffADL) > 0 AND (NOT((a96 IN (XT020_IntroDiffADL))) OR ((count(XT620_IntroDiffADLII) > 0 AND (NOT((a96 IN (XT620_IntroDiffADLII)))))
   ⊟
      XT022_HelpADL (ANYONE HELPED WITH ADL)
         Thinking about the activities that*[{Name of the deceased}]* had problems with during the last twelve months of*[his/ her]* life,
         has anyone helped regularly with these activities?
         1. Yes
         5. No

         IF ((XT022_HelpADL = a5 AND (XT009_YearDied > a14))
         ⊟
            XT133_CAHelpADL (NO HELP WITH ADL DUE TO CORONA)
               Was this due to the outbreak of corona?
               1. Yes
               2. Partly
               5. No

         ENDIF
         IF (XT022_HelpADL = a1)
         ⊟
            XT023_WhoHelpedADL (WHO HAS HELPED WITH ADL)
               Who, including yourself, has mainly helped with these activities? Please name up to three persons.
               do not read out
               at most three answers!
               code relationship to deceased!
               1. Yourself (proxy respondent)
               2. Husband or wife or partner of the deceased
               3. Mother or father of the deceased
               4. Son of the deceased
               5. Son-in-law of the deceased
               6. Daughter of the deceased
               7. Daughter-in-law of the deceased
               8. Grandson of the deceased
               9. Granddaughter of the deceased
               10. Sister of the deceased
               11. Brother of the deceased
               12. Other relative
               13. Unpaid volunteer
               14. Professional helper (e.g. nurse)
               15. Friend or neighbor of the deceased
               16. Other person

            CHECK: (NOT(count(XT023_WhoHelpedADL) > 3)) *[At most three answers;]*
            XT024_TimeRecHelp (TIME THE DECEASED RECEIVED HELP)
               Overall, during the last twelve months of*[his/ her]* life, for how long did*[{Name of the deceased}]* receive help?
               Read out.;
               1. Less than one month
               2. One month or more but less than 3 months
               3. 3 months or more but less than 6 months
               4. 6 months or more but less than a year
               5. A full year

               IF (XT009_YearDied > a14)
               ⊟
                  XT134_CATimeHelp (DID NOT RECEIVE HELP DUE TO CORONA)
                     At any other point in the last twelve months of*[his/ her]* life, did*[{Name of the deceased}]* need help and was
                     unable to receive it, because of the outbreak of corona?
                     1. Yes
                     5. No

                     IF (XT134_CATimeHelp = a1)
                     ⊟
                        XT135_CADurationNoHelp (HOW LONG NO HELP)
                           For how many weeks was*[{Name of the deceased}]* unable to receive help?
                           Count 1 for part of one week.
                           NUMBER [1..53]

                     ENDIF
               ENDIF
            XT025_HrsNecDay (HOURS OF HELP NECESSARY DURING TYPICAL DAY)
               And about how many hours of help did*[{Name of the deceased}]* receive during a typical day?
               NUMBER [0..24]

         ENDIF
   ENDIF

--- page 137 ---

XT026a_Intro (INTRODUCTION TO ASSETS)
   The next questions are about the assets and life insurance policies[{Name of the deceased}] may have owned and what happened to
   those assets after{he/ she} died. We would find it very helpful to have some information about the financial issues surrounding the
   time when people die. Before I continue, though, I'd like to assure you again that everything you have already told me and anything
   else you tell me will be kept completely confidential.
   1. Continue

XT026b_HadWill (THE DECEASED HAD A WILL)
   Some people make a will to determine who receives what parts of the estate.
   Did[{Name of the deceased}] have a will?
   1. Yes
   5. No

XT027_Benefic (THE BENEFICIARIES OF THE ESTATE)
   Who were the beneficiaries of the estate, including yourself?
   Read out.;
   Code all that apply.;
   1. Yourself (proxy)
   2. Husband or wife or partner of the deceased
   3. Children of the deceased
   4. Grandchildren of the deceased
   5. Siblings of the deceased
   6. Other relatives of the deceased
   7. Other non-relatives
   8. Church, foundation or charitable organization
   9. Deceased did not leave anything at all (SPONTANEOUS)
   10. Not decided yet (SPONTANEOUS)

CHECK: (NOT((count(XT027_Benefic) > 1 AND ((9 IN (XT027_Benefic)))) [You cannot select 'Did not leave anything' together with any
other answer. Please change your answer.;]
XT030_OwnHome (THE DECEASED OWNED HOME)
   Did[{Name of the deceased}] own{his/ her} home or apartment - either in total or a share of it?
   1. Yes
   5. No

   IF (XT030_OwnHome = a1)
   ⊟
        XT031_ValHome (VALUE HOME AFTER MORTGAGES)
           After any outstanding mortgages, what was the value of the home or apartment or the share of it owned by[{Name of the
           deceased}]?
           Enter an amount in ^FLCurr;
           If deceased left debt, code negative amount.
           NUMBER [-50000000..50000000]

           IF (XT031_ValHome = NONRESPONSE)
           ⊟
                |[Unfolding Bracket Sequence]
              ENDIF
        XT032_InhHome (WHO INHERITED THE HOME OF THE DECEASED)
           Who inherited the home or apartment of[{Name of the deceased}], including yourself?
           Code relationship to deceased.
           Code all that apply.;
           If the home or apartment is already sold, code all persons who got a share of the money.
           1. Yourself (proxy respondent)
           2. Husband or wife or partner
           3. Sons or daughters (ASK FOR FIRST NAMES)
           4. Grandchildren
           5. Siblings
           6. Other relatives
           7. Other non-relatives

           IF ((a3 IN (XT032_InhHome))
           ⊟
                XT053_FrstNme (FIRST NAMES CHILDREN)

                   First names of children who inherited home
                   STRING

              ENDIF
      ENDIF
XT033_OwnLifeInsPol (THE DECEASED OWNED ANY LIFE INSURANCE POLICIES)
   Did[{Name of the deceased}] own any life insurance policies?
   1. Yes
   5. No

   IF (XT033_OwnLifeInsPol = a1)
   ⊟
        XT034_ValLifeInsPol (VALUE OF ALL LIFE INSURANCE POLICIES)
           Approximately what was the total value of all life insurance policies owned by[{Name of the deceased}]?
           Enter an amount in ^FLCurr;
           NUMBER [0..1000000000000000000]

           IF (XT034_ValLifeInsPol = NONRESPONSE)
           ⊟
                |[Unfolding Bracket Sequence]
              ENDIF
        XT035_BenLifeInsPol (BENEFICIARIES OF THE LIFE INSURANCE POLICIES)
           Who were the beneficiaries of the life insurance policies, including yourself?
           Code relationship to deceased
           Code all that apply.;
           1. Yourself (proxy respondent)
           2. Husband or wife or partner

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 138 ---

3. Sons or daughters (ASK FOR FIRST NAMES)
            4. Grandchildren
            5. Siblings
            6. Other relatives (specify)
            7. Other non-relatives (specify)

            IF ((a6 IN (XT035_BenLifeInsPol))
            ⊟
                XT054_OthRel (OTHER RELATIVE)

                    Specify other relative
                    STRING

            ENDIF
            IF ((a7 IN (XT035_BenLifeInsPol))
            ⊟
                XT055_OthNonRel (OTHER NO-RELATIVE)

                    Specify other non-relative
                    STRING

            ENDIF
            IF ((a3 IN (XT035_BenLifeInsPol))
            ⊟
                XT056_FrstNme (FIRST NAMES CHILDREN)

                    First names of children who were beneficiaries
                    STRING

            ENDIF
        ENDIF
XT036_IntroAssets (INTRODUCTION TYPES OF ASSETS)
I will now read out a few types of assets people may have. For each item, please tell me whether{Name of the deceased}} owned
them at the time of{his/ her} death and, if so, please give your best estimate of their value after any outstanding debts.
1. Continue

 LOOP cnt := 1 TO 5
⊟
    XT637_OwnAss (THE DECEASED OWNED TYPE OF ASSETS)
        Did{he/ she} own any {businesses, including land or premises/ other real estate/ cars, except leased cars/ financial assets, e.g.
        cash, bonds or stocks/ jewelry or antiquities}?
        1. Yes
        5. No

        IF (XT637_OwnAss = a1)
        ⊟
            XT638_ValAss (VALUE TYPE OF ASSETS)
                About what was the value of the {businesses, including land or premises/ other real estate/ cars, except leased cars/
                financial assets, e.g. cash, bonds or stocks/ jewelry or antiquities} owned by{Name of the deceased}} at the time of{his/
                her} death?
                Enter an amount in ^FLCurr;
                If deceased left debt, code negative amount.
                NUMBER [-50000000..50000000]

                IF (XT638_ValAss = NONRESPONSE)
                ⊟
                        IF (piIndex = 1)
                        ⊟
                            [Unfolding Bracket Sequence]
                        ELSE
                        ⊟
                                IF (piIndex = 2)
                                ⊟
                                    [Unfolding Bracket Sequence]
                                ELSE
                                ⊟
                                        IF (piIndex = 3)
                                        ⊟
                                            [Unfolding Bracket Sequence]
                                        ELSE
                                        ⊟
                                                IF (piIndex = 4)
                                                ⊟
                                                    [Unfolding Bracket Sequence]
                                                ELSE
                                                ⊟
                                                        IF (piIndex = 5)
                                                        ⊟
                                                            [Unfolding Bracket Sequence]
                                                        ENDIF
                                                ENDIF
                                        ENDIF
                                ENDIF
                        ENDIF
                ENDIF
        ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 139 ---

[cnt]
   ENDLOOP     IF ((XT039_NumChild > 1 AND (NOT((a9 IN (XT027_Benefic))))
   ⊟
      |XT040a_EstateDiv (TOTAL ESTATE DIVIDED AMONG THE CHILDREN)
        How would you say that the total estate was divided among the children of{Name of the deceased}?
        Read out.;
        1. Some children received more than others
        2. The estate was divided about equally among all children
        3. The estate was distributed exactly among the children
        4. The children have not received anything
        5. Estate not divided yet (SPONTANEOUS ONLY)

         IF (XT040a_EstateDiv = a1)
         ⊟
            |XT040b_MoreForCare (SOME CHILDREN RECEIVED MORE FOR CARING)
               Would you say that some children received more than others to make up for previous gifts?
               1. Yes
               5. No

            XT040c_MoreFinSupp (SOME CHILDREN RECEIVED MORE TO GIVE THEM FINANCIAL SUPPORT)
               Would you say that some children received more than others to give them financial support?
               1. Yes
               5. No

            XT040d_MoreForCare (SOME CHILDREN RECEIVED MORE FOR CARING)
               Would you say that some children received more than others because they helped or cared for{Name of the deceased}
               towards the end of[his/ her] life?
               1. Yes
               5. No

            XT040e_MoreOthReas (SOME CHILDREN RECEIVED MORE FOR OTHER REASONS)
               Would you say that some children received more than others because of other reasons?
               1. Yes
               5. No

            ENDIF
   ENDIF
XT041_Funeral (THE FUNERAL WAS ACCOMPANIED BY A RELIGIOUS CEREMONY)
  Finally, we would like to know about the funeral of{Name of the deceased}. Was the funeral accompanied by a religious ceremony?
  1. Yes
  5. No

  IF (XT009_YearDied > a14)
  ⊟
      |XT136_CAFuneral (RESTRICTIONS FUNERAL DUE TO CORONA)
         We would also like to ask you how the outbreak of corona might have affected the funeral for{Name of the deceased}. Did you
         or other relatives of{Name of the deceased} face any restrictions for the funeral because of the outbreak of corona?
         1. Yes
         5. No

         IF (XT136_CAFuneral = a1)
         ⊟
            |XT137_CAFuneralRestriction (FUNERAL RESTRICTIONS)
               What kind of restrictions were these?
               Read out.; Code all that apply.;
               1. A funeral was not allowed.
               2. There was a limit on the number of people who could attend.
               3. Family or friends could not attend because of travel restrictions.
               4. Social distancing measures, such as hugging, shaking hands...
               5. Restrictions on family's choices, such as burial or funeral site.
               97. Other (please specify)

               IF ((a97 IN (XT137_CAFuneralRestriction))
               ⊟
                  |XT138_OthRestriction (OTHER RESTRICTION ON FUNERAL)
                     |
                     Specify other restriction on the funeral
                     STRING

               ENDIF
         ENDIF
   ENDIF
XT108_AnyElse (ANYTHING ELSE TO SAY ABOUT THE DECEASED)
  We have asked you many questions about numerous aspects of{Name of the deceased}'s health and finances, and we want to thank
  you very much for your assistance with them. Is there anything else you would like to add about the life circumstances of{Name of
  the deceased} in[his/ her] last year of life?
  If nothing to say, type none and press enter
  STRING

XT042_Outro (THANKS FOR THE INFORMATION)
  This is the end of the interview. Thank you once again for all the information you have given us. It will prove extremely useful in
  helping us to understand how people fare at the end of their lives
  1. Continue

XT043_IntMode (INTERVIEW MODE)

  Please state mode of interview
  1. Face-to-face
  2. Telephone

XT044_IntID (INTERVIEWER ID)

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]

--- page 140 ---

Your interviewer id.
         STRING
      ENDIF
   ENDIF
ENDIF

file:///H/Notizen/paperversion_en_GB_9_2_2a.html[30.05.2023 12:23:48]
