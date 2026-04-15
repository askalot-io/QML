# PCI_DSS_v4_SAQ_D_Merchant

- **source**: PCI_DSS_v4_SAQ_D_Merchant.pdf
- **model**: us.anthropic.claude-sonnet-4-6
- **dpi**: 150
- **pages**: 118

--- page 1 ---

Payment Card Industry
Data Security Standard

Self-Assessment Questionnaire D for Merchants
and Attestation of Compliance
For use with PCI DSS Version 4.0
Publication Date: April 2022

--- page 2 ---

Document Changes

Date         PCI DSS    SAQ          Description
             Version    Revision

October      1.2                     To align content with new PCI DSS v1.2 and to implement
2008                                 minor changes noted since original v1.1.

October      2.0                     To align content with new PCI DSS v2.0 requirements and
2010                                 testing procedures.

February     3.0                     To align content with PCI DSS v3.0 requirements and testing
2014                                 procedures and incorporate additional response options.

April 2015   3.1                     Updated to align with PCI DSS v3.1. For details of PCI DSS
                                     changes, see PCI DSS – Summary of Changes from PCI DSS
                                     Version 3.0 to 3.1.

July 2015    3.1        1.1          Updated to remove references to "best practices" prior to June
                                     30, 2015, and remove the PCI DSS v2 reporting option for
                                     Requirement 11.3.

April 2016   3.2        1.0          Updated to align with PCI DSS v3.2. For details of PCI DSS
                                     changes, see PCI DSS – Summary of Changes from PCI DSS
                                     Version 3.1 to 3.2.

January      3.2        1.1          Updated version numbering to align with other SAQs.
2017

June 2018    3.2.1      1.0          Updated to align with PCI DSS v3.2.1. For details of PCI DSS
                                     changes, see PCI DSS – Summary of Changes from PCI DSS
                                     Version 3.2 to 3.2.1.

April 2022   4.0        1.0          Updated to align with PCI DSS v4.0. For details of PCI DSS
                                     changes, see PCI DSS – Summary of Changes from PCI DSS
                                     Version 3.2.1 to 4.0.
                                     Rearranged, retitled, and expanded information in the
                                     "Completing the Self-Assessment Questionnaire" section
                                     (previously titled "Before You Begin").
                                     Aligned content in Sections 1 and 3 of Attestation of
                                     Compliance (AOC) with PCI DSS v4.0 Report on Compliance
                                     AOC.
                                     Added appendices to support new reporting responses.

PCI DSS v4.0 SAQ D for Merchants                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                   Page i

--- page 3 ---

Contents

Document Changes ................................................................................................................ i
Completing the Self-Assessment Questionnaire...................................................................iii
   Merchant Eligibility Criteria for Self-Assessment Questionnaire D ...................................................iii
   Defining Account Data, Cardholder Data, and Sensitive Authentication Data ................................iii
   PCI DSS Self-Assessment Completion Steps ................................................................................iv
   Expected Testing iv
   Requirement Responses .................................................................................................................. v
   Additional PCI SSC Resources  ....................................................................................................viii
Section 1:   Assessment Information ................................................................................... 1
Section 2:   Self-Assessment Questionnaire D for Merchants .............................................. 6
   Build and Maintain a Secure Network and Systems........................................................................ 6
      Requirement 1: Install and Maintain Network Security Controls ........................................................ 6
      Requirement 2: Apply Secure Configurations to All System Components......................................... 12
   Protect Account Data ...................................................................................................................16
      Requirement 3: Protect Stored Account Data.................................................................................... 16
      Requirement 4: Protect Cardholder Data with Strong Cryptography During Transmission
                              Over Open, Public Networks .................................................................................... 30
   Maintain a Vulnerability Management Program ..........................................................................33
      Requirement 5: Protect All Systems and Networks from Malicious Software .....................................33
      Requirement 6: Develop and Maintain Secure Systems and Software..............................................37
   Implement Strong Access Control Measures...............................................................................46
      Requirement 7: Restrict Access to System Components and Cardholder Data
                              by Business Need to Know........................................................................................ 46
      Requirement 8: Identify Users and Authenticate Access to System Components.............................. 50
      Requirement 9: Restrict Physical Access to Cardholder Data ........................................................... 63
   Regularly Monitor and Test Networks..........................................................................................70
      Requirement 10: Log and Monitor All Access to System Components and Cardholder Data ............. 70
      Requirement 11: Test Security of Systems and Networks Regularly ................................................. 77
   Maintain an Information Security Policy ......................................................................................88
      Requirement 12: Support Information Security with Organizational Policies and Programs ............... 88
   Appendix A: Additional PCI DSS Requirements .........................................................................101
      Appendix A1: Additional PCI DSS Requirements for Multi-Tenant Service Providers....................... 101
      Appendix A2: Additional PCI DSS Requirements for Entities using SSL/Early TLS
                              for Card-Present POS POI Terminal Connections .................................................... 101
      Appendix A3:      Designated Entities Supplemental Validation (DESV)........................................... 102
   Appendix B:         Compensating Controls Worksheet.....................................................................103
   Appendix C:         Explanation of Requirements Noted as In Place with Remediation ................104
   Appendix D:         Explanation of Requirements Noted as Not Applicable ..................................105
   Appendix E:         Explanation of Requirements Noted as Not Tested .........................................106
Section 3:   Validation and Attestation Details .................................................................107

PCI DSS v4.0 SAQ D for Merchants                                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                     Page ii

--- page 4 ---

Completing the Self-Assessment Questionnaire

Merchant Eligibility Criteria for Self-Assessment Questionnaire D

Self-Assessment Questionnaire (SAQ) D for Merchants applies to merchants that are eligible to complete a self-assessment questionnaire but do not meet the criteria for any other SAQ type. Examples of merchant environments to which SAQ D may apply include but are not limited to:

   ▪  E-commerce merchants that accept cardholder data on their website.

   ▪  Merchants with electronic storage of cardholder data.

   ▪  Merchants that don't store cardholder data electronically but that do not meet the criteria of another SAQ
      type.

   ▪  Merchants with environments that might meet the criteria of another SAQ type, but that have additional
      PCI DSS requirements applicable to their environment.

                              This SAQ is not applicable to service providers.

Defining Account Data, Cardholder Data, and Sensitive Authentication Data

PCI DSS is intended for all entities that store, process, or transmit cardholder data (CHD) and/or sensitive authentication data (SAD) or could impact the security of the cardholder data environment (CDE). Cardholder data and sensitive authentication data are considered account data and are defined as follows:

                                             Account Data

         Cardholder Data includes:                    Sensitive Authentication Data includes:

  • Primary Account Number (PAN)             • Full track data (magnetic-stripe data or equivalent on a chip)
  • Cardholder Name                          • Card verification code
  • Expiration Date                          • PINs/PIN blocks
  • Service Code

Refer to PCI DSS Section 2, PCI DSS Applicability Information, for further details.

PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                         Page iii

--- page 5 ---

PCI DSS Self-Assessment Completion Steps

1.   Confirm by review of the eligibility criteria in this SAQ and the *Self-Assessment Questionnaire Instructions and Guidelines* document on PCI SSC website that this is the correct SAQ for the merchant's environment.
2.   Confirm that the merchant environment is properly scoped.
3.   Assess environment for compliance with PCI DSS requirements.
4.   Complete all sections of this document:
     •   Section 1: Assessment Information (Parts 1 & 2 of the Attestation of Compliance (AOC) – Contact Information and Executive Summary).
     •   Section 2: Self-Assessment Questionnaire D for Merchants.
     •   Section 3: Validation and Attestation Details (Parts 3 & 4 of the AOC – PCI DSS Validation and Action Plan for Non-Compliant Requirements (if Part 4 is applicable)).
5.   Submit the SAQ and AOC, along with any other requested documentation—such as ASV scan reports—to the requesting organization (those organizations that manage compliance programs such as payment brands and acquirers).

**Expected Testing**

The instructions provided in the "Expected Testing" column are based on the testing procedures in PCI DSS and provide a high-level description of the types of testing activities that a merchant is expected to perform to verify that a requirement has been met.

The intent behind each testing method is described as follows:

   ▪   Examine: The merchant critically evaluates data evidence. Common examples include documents (electronic or physical), screenshots, configuration files, audit logs, and data files.

   ▪   Observe: The merchant watches an action or views something in the environment. Examples of observation subjects include personnel performing a task or process, system components performing a function or responding to input, environmental conditions, and physical controls.

   ▪   Interview: The merchant converses with individual personnel. Interview objectives may include confirmation of whether an activity is performed, descriptions of how an activity is performed, and whether personnel have particular knowledge or understanding.

The testing methods are intended to allow the merchant to demonstrate how it has met a requirement. The specific items to be examined or observed and personnel to be interviewed should be appropriate for both the requirement being assessed and the merchant's particular implementation.

Full details of testing procedures for each requirement can be found in PCI DSS.

*PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                          Page iv*

--- page 6 ---

Requirement Responses

For each requirement item, there is a choice of responses to indicate the merchant's status regarding that
requirement. Only one response should be selected for each requirement item.

A description of the meaning for each response is provided in the table below:

Response                    When to use this response:

In Place                    The expected testing has been performed, and all elements of the requirement have been met
                            as stated.

In Place with CCW           The expected testing has been performed, and the requirement has been met with the
                            assistance of a compensating control.
(Compensating
Controls Worksheet)         All responses in this column require completion of a Compensating Controls Worksheet
                            (CCW) in Appendix B of this SAQ.

                            Information on the use of compensating controls and guidance on how to complete the
                            worksheet is provided in PCI DSS Appendices B and C.

In Place with               The requirement was Not in Place when the expected testing was initially performed, but the
Remediation                 merchant addressed the situation and put processes in place to prevent re-occurrence prior to
                            completion of the self-assessment. In all cases of In Place with Remediation, the merchant
                            has identified and addressed the reason the control failed, has implemented the control, and
                            has implemented ongoing processes to prevent re-occurrence of the control failure.

                            All responses in this column require a supporting explanation in Appendix C of this SAQ.

Not Applicable              The requirement does not apply to the merchant's environment. (See "Guidance for Not
                            Applicable Requirements" below for examples.)All responses in this column require a
                            supporting explanation in Appendix D of this SAQ.

Not Tested                  The requirement was not included for consideration in the assessment and was not tested in
                            any way. (See "Understanding the Difference between Not Applicable and Not Tested" below
                            for examples of when this option should be used.)

                            All responses in this column require a supporting explanation in Appendix E of this SAQ.

Not in Place                Some or all elements of the requirement have not been met, or are in the process of being
                            implemented, or require further testing before the merchant can confirm they are in place.
                            Responses in this column may require the completion of Part 4, if requested by the entity to
                            which this SAQ will be submitted.

                            This response is also used if a requirement cannot be met due to a legal restriction. (See
                            "Legal Exception" below for more guidance).

PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                   Page v

--- page 7 ---

**Guidance for Not Applicable Requirements**

While many merchants completing SAQ D will need to validate compliance with every PCI DSS requirement, some entities with very specific business models may find that some requirements do not apply. For example, entities that do not use wireless technology in any capacity are not expected to comply with the PCI DSS requirements that are specific to managing wireless technology. Similarly, entities that do not store any account data electronically at any time are not expected to comply with the PCI DSS requirements related to secure storage of account data (for example, Requirement 3.5.1). Another example is requirements specific to application development and secure coding (for example, Requirements 6.2.1 through 6.2.4), which only apply to an entity with bespoke software (developed for the entity by a third party per the entity's specifications) or custom software (developed by the entity for its own use).

For each response where Not Applicable is selected in this SAQ, complete Appendix D: Explanation of Requirements Noted as Not Applicable.

**Understanding the Difference between Not Applicable and Not Tested**

Requirements that are deemed to be not applicable to an environment must be verified as such. Using the wireless example above, for an merchant to select "Not Applicable" for Requirements 1.3.3, 2.3.1, 2.3.2, and 4.2.1.2, the merchant first needs to confirm that there are no wireless technologies used in its cardholder data environment (CDE) or that connect to their CDE. Once this has been confirmed, the merchant may select "Not Applicable" for those specific requirements.

If a requirement is completely excluded from review without any consideration as to whether it *could* apply, the "Not Tested" option should be selected. Examples of situations where this could occur may include:

	▪	A merchant is asked by their acquirer to validate a subset of requirements—for example, using the PCI DSS Prioritized Approach to validate only certain milestones.

An merchant is confirming a new security control that impacts only a subset of requirements—for example, implementation of a new encryption methodology that only requires assessment of PCI DSS Requirements 2, 3, and 4.In these scenarios, the merchant's assessment only includes certain PCI DSS requirements even though other requirements might also apply to its environment.

If any requirements are completely excluded from the merchant's self-assessment, select Not Tested for that specific requirement, and complete Appendix E: Explanation of Requirements Not Tested for each "Not Tested" entry. An assessment with any Not Tested responses is a "Partial" PCI DSS assessment and will be noted as such by the merchant in the Attestation of Compliance in Section 3, Part 3 of this SAQ.

*PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ*                                                    *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                                      *Page vi*

--- page 8 ---

**Legal Exception**

If your organization is subject to a legal restriction that prevents the organization from meeting a PCI DSS requirement, select Not in Place for that requirement and complete the relevant attestation in Section 3, Part 3 of this SAQ.

**Note:** *A legal restriction is one where meeting the PCI DSS requirement would violate a local or regional law or regulation.*
*Contractual obligations or legal advice are not legal restrictions.*

**Use of the Customized Approach**

SAQs cannot be used to document use of the Customized Approach to meet PCI DSS requirements. For this reason, the Customized Approach Objectives are not included in SAQs. Entities wishing to validate using the Customized Approach may be able to use the PCI DSS Report on Compliance (ROC) Template to document the results of their assessment.

*Use of the Customized Approach is not supported in SAQs.*

The use of the customized approach may be regulated by organizations that manage compliance programs, such as payment brands and acquirers. Questions about use of a customized approach should always be referred to those organizations. This includes whether an entity that is eligible for an SAQ may instead complete a ROC to use a customized approach, and whether an entity is required to use a QSA, or may use an ISA, to complete an assessment using the customized approach. Information about the use of the Customized Approach can be found in Appendix D and E of PCI DSS.

*PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ* April 2022
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.* Page vii

--- page 9 ---

Additional PCI SSC Resources

Additional resources that provide guidance on PCI DSS requirements and how to complete the self-assessment questionnaire have been provided below to assist with the assessment process.

Resource                                    Includes:

PCI DSS                                     ▪    Guidance on Scoping
                                            ▪    Guidance on the intent of all PCI DSS Requirements
(PCI Data Security Standard                 ▪    Details of testing procedures
Requirements and Testing Procedures)        ▪    Guidance on Compensating Controls
                                            ▪    Appendix G: Glossary of Terms, Abbreviations, and
                                                 Acronyms

SAQ Instructions and Guidelines            ▪    Information about all SAQs and their eligibility criteria
                                            ▪    How to determine which SAQ is right for your
                                                 organization

Frequently Asked Questions (FAQs)          ▪    Guidance and information about SAQs.

Online PCI DSS Glossary                    ▪    PCI DSS Terms, Abbreviations, and Acronyms

Information Supplements and Guidelines     ▪    Guidance on a variety of PCI DSS topics including:
                                                 –    Understanding PCI DSS Scoping and Network
                                                      Segmentation
                                                 –    Third-Party Security Assurance
                                                 –    Multi-Factor Authentication Guidance
                                                 –    Best Practices for Maintaining PCI DSS
                                                      Compliance

Getting Started with PCI                   ▪    Resources for smaller merchants including:
                                                 –    Guide to Safe Payments
                                                 –    Common Payment Systems
                                                 –    Questions to Ask Your Vendors
                                                 –    Glossary of Payment and Information Security
                                                      Terms
                                                 –    PCI Firewall Basics

These and other resources can be found on the PCI SSC website (www.pcisecuritystandards.org).

Organizations are encouraged to review PCI DSS and other supporting documents before beginning an assessment.

PCI DSS v4.0 SAQ D for Merchants, Completing the SAQ                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                             Page viii

--- page 10 ---

Section 1: Assessment Information

*Instructions for Submission*

This document must be completed as a declaration of the results of the merchant's self-assessment against the
*Payment Card Industry Data Security Standard (PCI DSS) Requirements and Testing Procedures.* Complete all
sections. The merchant is responsible for ensuring that each section is completed by the relevant parties, as
applicable. Contact the entity(ies) to which the Attestation of Compliance (AOC) will be submitted for reporting and
submission procedures.

Part 1. Contact Information

   Part 1a. Assessed Merchant

Company Name:
DBA (doing business as):
Company mailing address:
Company main website:
Company Contact Name:
Company contact title:
Contact phone number:
Contact e-mail address:

   Part 1b. Assessor

Provide the following information for all assessors involved in the assessment. If there was no assessor
for a given assessor type, enter Not Applicable.

PCI SSC Internal Security Assessor(s)
ISA name(s):
Qualified Security Assessor
Company Name:
Company mailing address:
Company website:
Lead Assessor Name:
Assessor phone number:
Assessor e-mail address:
Assessor certificate number:

*PCI DSS v4.0 SAQ D for Merchants, Section 1: AOC Assessment Information*                    April 2022
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                         Page 1

--- page 11 ---

Part 2. Executive Summary

   Part 2a. Merchant Business Payment Channels (select all that apply):

Indicate all payment channels used by the business that are included in this assessment.

___ Mail order/telephone order (MOTO)

___ E-Commerce

___ Card-present

Are any payment channels not          ___ Yes   ___ No
included in this assessment?
If yes, indicate which channel(s) is not
included in the assessment and
provide a brief explanation about why
the channel was excluded.

   *Note: If the organization has a payment channel that is not covered by this SAQ, consult with the entity(ies) to which this AOC will be submitted about validation for the other channels.*

   Part 2b. Description of Role with Payment Cards

For each payment channel included in this assessment as selected in Part 2a above, describe how the business stores, processes, and/or transmits account data.

Channel                    How Business Stores, Processes, and/or Transmits Account Data




   Part 2c. Description of Payment Card Environment

Provide a **high-level** description of the environment
covered by this assessment.
*For example:*
*• Connections into and out of the cardholder data*
   *environment (CDE).*
*• Critical system components within the CDE, such as POI*
   *devices, databases, web servers, etc., and any other*
   *necessary payment components, as applicable.*
*• System components that could impact the security of*
   *account data.*

Indicate whether the environment includes segmentation to reduce the scope of the    ___ Yes   ___ No
assessment.
*(Refer to "Segmentation" section of PCI DSS for guidance on segmentation.)*

PCI DSS v4.0 SAQ D for Merchants, Section 1: AOC Assessment Information                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                Page 2

--- page 12 ---

Part 2. Executive Summary *(continued)*

**Part 2d. In-Scope Locations/Facilities**

List all types of physical locations/facilities (for example, corporate offices, data centers, call centers, and mail rooms) in scope for the PCI DSS assessment.

 Facility Type                    Total number of locations                    Location(s) of facility (city, country)
                                  (How many locations of this
                                  type are in scope)

*Example: Data centers*           *3*                                          *Boston, MA, USA*




**Part 2e. PCI SSC Validated Products and Solutions**

Does the merchant use any item identified on any PCI SSC Lists of Validated Products and Solutions✦?

☐ Yes   ☐ No

Provide the following information regarding each item the merchant uses from PCI SSC's Lists of Validated Products and Solutions.

 Name of PCI SSC-          Version of          PCI SSC Standard to          PCI SSC listing          Expiry date of listing
 validated Product or      Product or          which product or             reference                (YYYY-MM-DD)
 Solution                  Solution            solution was validated        number

                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD
                                                                                                      YYYY-MM-DD

---

✦ For purposes of this document, "Lists of Validated Products and Solutions" means the lists of validated products, solutions, and/or components appearing on the PCI SSC website (www.pcisecuritystandards.org)—for example, 3DS Software Development Kits, Approved PTS Devices, Validated Payment Software, Payment Applications (PA-DSS), Point to Point Encryption (P2PE) solutions, Software-Based PIN Entry on COTS (SPoC) solutions, and Contactless Payments on COTS (CPoC) solutions.

*PCI DSS v4.0 SAQ D for Merchants, Section 1: AOC Assessment Information*                            *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                              *Page 3*

--- page 13 ---

Part 2. Executive Summary *(continued)*

   Part 2f. Third-Party Service Providers

   Does the merchant have relationships with one or more third-party service providers that:

   •  Store, process, or transmit account data on the merchant's behalf (for example, payment        ___ Yes   ___ No
      gateways, payment processors, payment service providers (PSPs), and off-site storage)

   •  Manage system components included in the scope of the merchant's PCI DSS                     ___ Yes   ___ No
      assessment—for example, via network security control services, anti-malware services,
      security incident and event management (SIEM), contact and call centers, web-hosting
      services, and IaaS, PaaS, SaaS, and FaaS cloud providers.

   •  Could impact the security of the merchant's CDE (for example, vendors providing              ___ Yes   ___ No
      support via remote access, and/or bespoke software developers)

*If Yes:*

Name of service provider:                    Description of service(s) provided:




*Note:* Requirement 12.8 applies to all entities in this list.

*PCI DSS v4.0 SAQ D for Merchants, Section 1: AOC Assessment Information*                         April 2022
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                           Page 4

--- page 14 ---

Part 2. Executive Summary *(continued)*

**Part 2g. Summary of Assessment**
*(SAQ Section 2 and related appendices)*

*Indicate below all responses that were selected for each PCI DSS requirement.*

                                          Requirement Responses
                         More than one response may be selected for a given requirement.
PCI DSS                              Indicate all responses that apply.
Requirement      In Place    In Place with    In Place with       Not        Not Tested    Not in Place
                                 CCW          Remediation      Applicable

Requirement 1:   ___         ___              ___               ___         ___           ___

Requirement 2:   ___         ___              ___               ___         ___           ___

Requirement 3:   ___         ___              ___               ___         ___           ___

Requirement 4:   ___         ___              ___               ___         ___           ___

Requirement 5:   ___         ___              ___               ___         ___           ___

Requirement 6:   ___         ___              ___               ___         ___           ___

Requirement 7:   ___         ___              ___               ___         ___           ___

Requirement 8:   ___         ___              ___               ___         ___           ___

Requirement 9:   ___         ___              ___               ___         ___           ___

Requirement 10:  ___         ___              ___               ___         ___           ___

Requirement 11:  ___         ___              ___               ___         ___           ___

Requirement 12:  ___         ___              ___               ___         ___           ___

Appendix A2:     ___         ___              ___               ___         ___           ___

*PCI DSS v4.0 SAQ D for Merchants, Section 1: AOC Assessment Information*                    *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                       *Page 5*

--- page 15 ---

Section 2: Self-Assessment Questionnaire D for Merchants

*Note: The following requirements mirror the requirements in the* PCI DSS Requirements and Testing Procedures *document.*

                                                                                              **Self-assessment completion date:** YYYY-MM-DD

**Build and Maintain a Secure Network and Systems**

*Requirement 1: Install and Maintain Network Security Controls*

                                                                                    Response♦
                                                                               (Check one response for each requirement)
   PCI DSS Requirement                              Expected Testing        In       In Place    In Place with    Not        Not      Not in
                                                                           Place     with CCW    Remediation    Applicable  Tested    Place

1.1 Processes and mechanisms for installing and maintaining network security controls are defined and understood.

1.1.1  All security policies and operational procedures that are    •  Examine documentation.    □    □    □    □    □    □
       identified in Requirement 1 are:                             •  Interview personnel.
       •  Documented.
       •  Kept up to date.
       •  In use.
       •  Known to all affected parties.

1.1.2  Roles and responsibilities for performing activities in      •  Examine documentation.    □    □    □    □    □    □
       Requirement 1 are documented, assigned, and                  •  Interview responsible
       understood.                                                     personnel.

1.2 Network security controls (NSCs) are configured and maintained.

1.2.1  Configuration standards for NSC rulesets are:               •  Examine configurations    □    □    □    □    □    □
       •  Defined.                                                     standards.
       •  Implemented.                                              •  Examine configuration
       •  Maintained.                                                  settings.

♦ *Refer to the "Requirement Responses" section (page v) for information about these response options.*

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                             Page 6

--- page 16 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

1.2.2   All changes to network connections and to configurations   •  Examine documented        □       □           □               □           □        □
        of NSCs are approved and managed in accordance with           procedures.
        the change control process defined at Requirement          •  Examine network
        6.5.1.                                                        configurations.
                                                                   •  Examine change control
                                                                      records.
                                                                   •  Interview responsible
                                                                      personnel.

        Applicability Notes

        Changes to network connections include the addition, removal, or modification of a
        connection.
        Changes to NSC configurations include those related to the component itself as well as
        those affecting how it performs its security function.

1.2.3   An accurate network diagram(s) is maintained that          •  Examine network           □       □           □               □           □        □
        shows all connections between the CDE and other               diagrams.
        networks, including any wireless networks.                 •  Examine network
                                                                      configurations.
                                                                   •  Interview responsible
                                                                      personnel.

        Applicability Notes

        A current network diagram(s) or other technical or topological solution that identifies
        network connections and devices can be used to meet this requirement.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 7

--- page 17 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

1.2.4   An accurate data-flow diagram(s) is maintained that    •  Examine data flow        □       □            □                □            □         □
        meets the following:                                      diagrams.
        •  Shows all account data flows across systems and     •  Observe network
           networks.                                              configurations.
        •  Updated as needed upon changes to the              •  Examine documentation.
           environment.                                        •  Interview responsible
                                                                  personnel.
        Applicability Notes

        A data-flow diagram(s) or other technical or topological solution that identifies flows of
        account data across systems and networks can be used to meet this requirement.

1.2.5   All services, protocols and ports allowed are identified,   •  Examine documentation.   □       □            □                □            □         □
        approved, and have a defined business need.                 •  Examine configuration
                                                                       settings.

1.2.6   Security features are defined and implemented for all       •  Examine documentation.   □       □            □                □            □         □
        services, protocols, and ports that are in use and          •  Examine configuration
        considered to be insecure, such that the risk is mitigated.    settings.

1.2.7   Configurations of NSCs are reviewed at least once every     •  Examine documented       □       □            □                □            □         □
        six months to confirm they are relevant and effective.         procedures.
                                                                    •  Examine documentation
                                                                       from reviews performed.
                                                                    •  Examine configuration
                                                                       settings.

1.2.8   Configuration files for NSCs are:                           •  Examine NSC              □       □            □                □            □         □
        •  Secured from unauthorized access.                           configuration files.
        •  Kept consistent with active network configurations.

        Applicability Notes

        Any file or setting used to configure or synchronize NSCs is considered to be a
        "configuration file." This includes files, automated and system-based controls, scripts,
        settings, infrastructure as code, or other parameters that are backed up, archived, or
        stored remotely.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                         April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                              Page 8

--- page 18 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                                        In      In Place    In Place with    Not        Not      Not in
                                                       Place    with CCW    Remediation   Applicable  Tested    Place

1.3 Network access to and from the cardholder data environment is restricted.

1.3.1   Inbound traffic to the CDE is restricted as follows:        •  Examine NSC              □        □           □            □         □        □
        •  To only traffic that is necessary,                          configuration standards.
        •  All other traffic is specifically denied.               •  Examine NSC
                                                                      configurations.

1.3.2   Outbound traffic from the CDE is restricted as follows:    •  Examine NSC              □        □           □            □         □        □
        •  To only traffic that is necessary.                         configuration standards.
        •  All other traffic is specifically denied.               •  Examine NSC
                                                                      configurations.

1.3.3   NSCs are installed between all wireless networks and       •  Examine configuration    □        □           □            □         □        □
        the CDE, regardless of whether the wireless network is a      settings.
        CDE, such that:                                            •  Examine network
        •  All wireless traffic from wireless networks into the       diagrams.
           CDE is denied by default.
        •  Only wireless traffic with an authorized business
           purpose is allowed into the CDE.

1.4 Network connections between trusted and untrusted networks are controlled.

1.4.1   NSCs are implemented between trusted and untrusted         •  Examine NSC              □        □           □            □         □        □
        networks.                                                     configuration standards.
                                                                   •  Examine current network
                                                                      diagrams.
                                                                   •  Examine network
                                                                      configurations.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 9

--- page 19 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

1.4.2   Inbound traffic from untrusted networks to trusted          • Examine NSC              □          □            □             □          □        □
        networks is restricted to:                                    documentation.
        • Communications with system components that are            • Examine NSC
          authorized to provide publicly accessible services,         configurations.
          protocols, and ports.
        • Stateful responses to communications initiated by
          system components in a trusted network.
        • All other traffic is denied.

        Applicability Notes

        The intent of this requirement is to address communication sessions between trusted and
        untrusted networks, rather than the specifics of protocols.
        This requirement does not limit the use of UDP or other connectionless network protocols
        if state is maintained by the NSC.

1.4.3   Anti-spoofing measures are implemented to detect and        • Examine NSC              □          □            □             □          □        □
        block forged source IP addresses from entering the            documentation.
        trusted network.                                            • Examine NSC
                                                                      configurations.

1.4.4   System components that store cardholder data are not        • Examine the data-flow    □          □            □             □          □        □
        directly accessible from untrusted networks.                  diagram and network
                                                                      diagram.
                                                                    • Examine NSC
                                                                      configurations.

        Applicability Notes

        This requirement is not intended to apply to storage of account data in volatile memory
        but does apply where memory is being treated as persistent storage (for example, RAM
        disk). Account data can only be stored in volatile memory during the time necessary to
        support the associated business process (for example, until completion of the related
        payment card transaction).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 10

--- page 20 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In       In Place      In Place with    Not          Not        Not in
                                                    Place    with CCW      Remediation      Applicable   Tested     Place

1.4.5   The disclosure of internal IP addresses and routing    •  Examine NSC              □        □             □                □            □          □
        information is limited to only authorized parties.       configurations.
                                                               •  Examine documentation.
                                                               •  Interview responsible
                                                                  personnel.

1.5 Risks to the CDE from computing devices that are able to connect to both untrusted networks and the CDE are mitigated.

1.5.1   Security controls are implemented on any computing     •  Examine policies and     □        □             □                □            □          □
        devices, including company- and employee-owned            configuration standards.
        devices, that connect to both untrusted networks       •  Examine device
        (including the Internet) and the CDE as follows.          configuration settings.
        •  Specific configuration settings are defined to prevent
           threats being introduced into the entity's network.
        •  Security controls are actively running.
        •  Security controls are not alterable by users of the
           computing devices unless specifically documented
           and authorized by management on a case-by-case
           basis for a limited period.

        Applicability Notes

        These security controls may be temporarily disabled only if there is legitimate technical
        need, as authorized by management on a case-by-case basis. If these security controls
        need to be disabled for a specific purpose, it must be formally authorized. Additional
        security measures may also need to be implemented for the period during which these
        security controls are not active.
        This requirement applies to employee-owned and company-owned computing devices.
        Systems that cannot be managed by corporate policy introduce weaknesses and provide
        opportunities that malicious individuals may exploit.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                           April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                Page 11

--- page 21 ---

Requirement 2: Apply Secure Configurations to All System Components

PCI DSS Requirement                                Expected Testing                    Response♦
                                                                              (Check one response for each requirement)
                                                                         In       In Place    In Place with    Not        Not      Not in
                                                                        Place    with CCW     Remediation   Applicable  Tested    Place

2.1 Processes and mechanisms for applying secure configurations to all system components are defined and understood.

2.1.1   All security policies and operational procedures that      •  Examine documentation.        □        □           □           □         □        □
        are identified in Requirement 2 are:                       •  Interview personnel.
        •  Documented.
        •  Kept up to date.
        •  In use.
        •  Known to all affected parties.

2.1.2   Roles and responsibilities for performing activities in    •  Examine documentation.        □        □           □           □         □        □
        Requirement 2 are documented, assigned, and               •  Interview responsible
        understood.                                                   personnel.

2.2 System components are configured and managed securely.

2.2.1   Configuration standards are developed, implemented,       •  Examine system                 □        □           □           □         □        □
        and maintained to:                                            configuration standards.
        •  Cover all system components.                           •  Review industry-accepted
        •  Address all known security vulnerabilities.               hardening standards.
        •  Be consistent with industry-accepted system            •  Examine configuration
           hardening standards or vendor hardening                   settings.
           recommendations.                                       •  Interview personnel.
        •  Be updated as new vulnerability issues are
           identified, as defined in Requirement 6.3.1.
        •  Be applied when new systems are configured and
           verified as in place before or immediately after a
           system component is connected to a production
           environment.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                  Page 12

--- page 22 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In      In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

2.2.2   Vendor default accounts are managed as follows:          •  Examine system              □        □           □            □         □        □
        •  If the vendor default account(s) will be used, the       configuration standards.
           default password is changed per Requirement           •  Examine vendor
           8.3.6.                                                   documentation.
        •  If the vendor default account(s) will not be used,   •  Observe a system
           the account is removed or disabled.                      administrator logging on
                                                                    using vendor default
                                                                    accounts.
                                                                 •  Examine configuration files.
                                                                 •  Interview personnel.

        Applicability Notes

        This applies to ALL vendor default accounts and passwords, including, but not limited to,
        those used by operating systems, software that provides security services, application
        and system accounts, point-of-sale (POS) terminals, payment applications, and Simple
        Network Management Protocol (SNMP) defaults.

        This requirement also applies where a system component is not installed within an entity's
        environment, for example, software and applications that are part of the CDE and are
        accessed via a cloud subscription service.

2.2.3   Primary functions requiring different security levels are  •  Examine system            □        □           □            □         □        □
        managed as follows:                                           configuration standards.
        •  Only one primary function exists on a system          •  Examine system
           component,                                               configurations.
           OR
        •  Primary functions with differing security levels that
           exist on the same system component are isolated
           from each other,
           OR
        •  Primary functions with differing security levels on
           the same system component are all secured to the
           level required by the function with the highest
           security need.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                   Page 13

--- page 23 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW     Remediation   Applicable  Tested    Place

2.2.4   Only necessary services, protocols, daemons, and        • Examine system              □        □            □            □         □        □
        functions are enabled, and all unnecessary                configuration standards.
        functionality is removed or disabled.                   • Examine system
                                                                  configurations.

2.2.5   If any insecure services, protocols, or daemons are     • Examine configuration       □        □            □            □         □        □
        present:                                                  standards.
        • Business justification is documented.                 • Interview personnel.
        • Additional security features are documented and       • Examine configuration
          implemented that reduce the risk of using insecure      settings.
          services, protocols, or daemons.

2.2.6   System security parameters are configured to prevent    • Examine system              □        □            □            □         □        □
        misuse.                                                   configuration standards.
                                                                • Interview personnel.
                                                                • Examine system
                                                                  configurations.

2.2.7   All non-console administrative access is encrypted      • Examine system              □        □            □            □         □        □
        using strong cryptography.                                configuration standards.
                                                                • Observe an administrator
                                                                  log on.
                                                                • Examine system
                                                                  configurations.
                                                                • Examine vendor
                                                                  documentation.
                                                                • Interview personnel.

        Applicability Notes

        This includes administrative access via browser-based interfaces and application
        programming interfaces (APIs).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 14

--- page 24 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW     Remediation   Applicable  Tested    Place

2.3 Wireless environments are configured and managed securely.

2.3.1   For wireless environments connected to the CDE or          • Examine policies and         □        □           □            □         □        □
        transmitting account data, all wireless vendor defaults       procedures.
        are changed at installation or are confirmed to be          • Review vendor
        secure, including but not limited to:                         documentation.
        • Default wireless encryption keys.                        • Examine wireless
        • Passwords on wireless access points.                       configuration settings.
        • SNMP defaults.                                           • Interview personnel.
        • Any other security-related wireless vendor defaults.

        Applicability Notes

        This includes, but is not limited to, default wireless encryption keys, passwords on
        wireless access points, SNMP defaults, and any other security-related wireless vendor
        defaults.

2.3.2   For wireless environments connected to the CDE or          • Examine key-management        □        □           □            □         □        □
        transmitting account data, wireless encryption keys are       documentation.
        changed as follows:                                         • Interview personnel.
        • Whenever personnel with knowledge of the key
          leave the company or the role for which the
          knowledge was necessary.
        • Whenever a key is suspected of or known to be
          compromised.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                              Page 15

--- page 25 ---

Protect Account Data

Requirement 3: Protect Stored Account Data

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                 (Check one response for each requirement)
                                                                                        In       In Place      In Place with    Not          Not       Not in
                                                                                        Place    with CCW      Remediation      Applicable   Tested    Place

3.1 Processes and mechanisms for protecting stored account data are defined and understood.

3.1.1   All security policies and operational procedures that are    • Examine documentation.    □        □             □                □            □         □
        identified in Requirement 3 are:                             • Interview personnel.
        • Documented.
        • Kept up to date.
        • In use.
        • Known to all affected parties.

3.1.2   Roles and responsibilities for performing activities in      • Examine documentation.    □        □             □                □            □         □
        Requirement 3 are documented, assigned, and                  • Interview responsible
        understood.                                                     personnel.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                           April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 16

--- page 26 ---

PCI DSS Requirement                          Expected Testing                                    Response*
                                                                                          (Check one response for each requirement)
                                                                                 In       In Place    In Place with    Not        Not      Not in
                                                                                Place    with CCW    Remediation    Applicable  Tested    Place

3.2 Storage of account data is kept to a minimum.

3.2.1    Account data storage is kept to a minimum through          •   Examine the data              □        □           □            □         □        □
         implementation of data retention and disposal policies,        retention and disposal
         procedures, and processes that include at least the            policies, procedures, and
         following:                                                     processes.
         •   Coverage for all locations of stored account data.    •   Interview personnel.
         •   Coverage for any sensitive authentication data (SAD)  •   Examine files and system
             stored prior to completion of authorization. This bullet   records on system
             is a best practice until its effective date; refer to      components where
             Applicability Notes below for details.                     account data is stored.
         •   Limiting data storage amount and retention time to    •   Observe the mechanisms
             that which is required for legal or regulatory, and/or     used to render account
             business requirements.                                     data unrecoverable.
         •   Specific retention requirements for stored account
             data that defines length of retention period and
             includes a documented business justification.
         •   Processes for secure deletion or rendering account
             data unrecoverable when no longer needed per the
             retention policy.
         •   A process for verifying, at least once every three
             months, that stored account data exceeding the
             defined retention period has been securely deleted or
             rendered unrecoverable.

         Applicability Notes

         Where account data is stored by a TPSP (for example, in a cloud environment), entities
         are responsible for working with their service providers to understand how the TPSP
         meets this requirement for the entity. Considerations include ensuring that all geographic
         instances of a data element are securely deleted.
         The bullet above (for coverage of SAD stored prior to completion of authorization) is a
         best practice until 31 March 2025, after which it will be required as part of Requirement
         3.2.1 and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 17

--- page 27 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

3.3 Sensitive authentication data (SAD) is not stored after authorization.

3.3.1    SAD is not retained after authorization, even if          •  Examine documented           □        □           □            □         □        □
         encrypted. All sensitive authentication data received is     policies and procedures.
         rendered unrecoverable upon completion of the             •  Examine system
         authorization process.                                       configurations.
                                                                   •  Observe the secure data
                                                                      deletion processes.

         Applicability Notes

         Part of this Applicability Note was intentionally removed for this SAQ as it does not apply
         to merchant assessments.
         Sensitive authentication data includes the data cited in Requirements 3.3.1.1 through
         3.3.1.3.

3.3.1.1  The full contents of any track are not retained upon      •  Examine data sources.        □        □           □            □         □        □
         completion of the authorization process.

         Applicability Notes

         In the normal course of business, the following data elements from the track may need to
         be retained:
         •  Cardholder name.
         •  Primary account number (PAN).
         •  Expiration date.
         •  Service code.
         To minimize risk, store securely only these data elements as needed for business.

3.3.1.2  The card verification code is not retained upon           •  Examine data sources.        □        □           □            □         □        □
         completion of the authorization process.

         Applicability Notes

         The card verification code is the three- or four-digit number printed on the front or back of
         a payment card used to verify card-not-present transactions.


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 18

--- page 28 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not          Not      Not in
                                              Place   with CCW    Remediation     Applicable   Tested   Place

3.3.1.3   The personal identification number (PIN) and the PIN    •  Examine data sources.   □   □   □   □   □   □
          block are not retained upon completion of the
          authorization process.

          Applicability Notes

          PIN blocks are encrypted during the natural course of transaction processes, but even if
          an entity encrypts the PIN block again, it is still not allowed to be stored after the
          completion of the authorization process.

3.3.2     SAD that is stored electronically prior to completion of    •  Examine data stores and    □   □   □   □   □   □
          authorization is encrypted using strong cryptography.          system configurations.
                                                                     •  Examine vendor
                                                                         documentation.

          Applicability Notes

          Whether SAD is permitted to be stored prior to authorization is determined by the
          organizations that manage compliance programs (for example, payment brands and
          acquirers). Contact the organizations of interest for any additional criteria.

          This requirement applies to all storage of SAD, even if no PAN is present in the
          environment.

          Refer to Requirement 3.2.1 for an additional requirement that applies if SAD is stored
          prior to completion of authorization.

          Part of this Applicability Note was intentionally removed for this SAQ as it does not apply
          to merchant assessments.

          This requirement does not replace how PIN blocks are required to be managed, nor does
          it mean that a properly encrypted PIN block needs to be encrypted again.

          This requirement is a best practice until 31 March 2025, after which it will be required and
          must be fully considered during a PCI DSS assessment.

3.3.3     Additional requirement for service providers only


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                               Page 19

--- page 29 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place    In Place with    Not         Not      Not in
                                                                             Place    with CCW    Remediation    Applicable   Tested    Place

3.4 Access to displays of full PAN and ability to copy PAN is restricted.

3.4.1   PAN is masked when displayed (the BIN and last four      •  Examine documented           □        □           □            □         □        □
        digits are the maximum number of digits to be               policies and procedures.
        displayed), such that only personnel with a legitimate    •  Examine system
        business need can see more than the BIN and last four       configurations.
        digits of the PAN.                                       •  Examine the documented
                                                                    list of roles that need
                                                                    access to more than the
                                                                    BIN and last four digits of
                                                                    the PAN (includes full
                                                                    PAN).
                                                                 •  Examine displays of PAN
                                                                    (for example, on screen,
                                                                    on paper receipts).

        Applicability Notes

        This requirement does not supersede stricter requirements in place for displays of
        cardholder data—for example, legal or payment brand requirements for point-of-sale
        (POS) receipts.
        This requirement relates to protection of PAN where it is displayed on screens, paper
        receipts, printouts, etc., and is not to be confused with Requirement 3.5.1 for protection of
        PAN when stored, processed, or transmitted.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 20

--- page 30 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not          Not      Not in
                                              Place   with CCW    Remediation     Applicable   Tested   Place

3.4.2   When using remote-access technologies, technical        • Examine documented            □       □           □               □            □        □
        controls prevent copy and/or relocation of PAN for all    policies and procedures
        personnel, except for those with documented, explicit     and documented evidence
        authorization and a legitimate, defined business need.    for technical controls.
                                                               • Examine configurations
                                                                 for remote-access
                                                                 technologies.
                                                               • Observe processes.
                                                               • Interview personnel.

        Applicability Notes

        Storing or relocating PAN onto local hard drives, removable electronic media, and other
        storage devices brings these devices into scope for PCI DSS.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                           April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                Page 21

--- page 31 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

3.5 Primary account number (PAN) is secured wherever it is stored.

3.5.1   PAN is rendered unreadable anywhere it is stored by    •  Examine documentation        □       □           □               □           □        □
        using any of the following approaches:                    about the system used to
        •  One-way hashes based on strong cryptography of         render PAN unreadable.
           the entire PAN.                                     •  Examine data
        •  Truncation (hashing cannot be used to replace the      repositories.
           truncated segment of PAN).                          •  Examine audit logs,
           –  If hashed and truncated versions of the same        including payment
              PAN, or different truncation formats of the same    application logs.
              PAN, are present in an environment, additional    •  Examine controls to verify
              controls are in place such that the different        that the hashed and
              versions cannot be correlated to reconstruct the     truncated PANs cannot be
              original PAN                                        correlated to reconstruct
        •  Index tokens.                                          the original PAN.
        •  Strong cryptography with associated key-
           management processes and procedures.

        Applicability Notes

        It is a relatively trivial effort for a malicious individual to reconstruct original PAN data if
        they have access to both the truncated and hashed version of a PAN.
        This requirement applies to PANs stored in primary storage (databases, or flat files such
        as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception,
        or troubleshooting logs) must all be protected.
        This requirement does not preclude the use of temporary files containing cleartext PAN
        while encrypting and decrypting PAN

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 22

--- page 32 ---

PCI DSS Requirement                          Expected Testing                                    Response*
                                                                                          (Check one response for each requirement)
                                                                                    In       In Place    In Place with    Not        Not      Not in
                                                                                    Place    with CCW    Remediation      Applicable Tested   Place

3.5.1.1   Hashes used to render PAN unreadable (per the first    • Examine documentation        □        □           □               □          □        □
          bullet of Requirement 3.5.1), are keyed cryptographic    about the hashing method
          hashes of the entire PAN, with associated key-           used.
          management processes and procedures in accordance      • Examine documentation
          with Requirements 3.6 and 3.7.                           about the key-
                                                                   management procedures
                                                                   and processes.
                                                                 • Examine data
                                                                   repositories.
                                                                 • Examine audit logs,
                                                                   including payment
                                                                   application logs.

          Applicability Notes

          This requirement applies to PANs stored in primary storage (databases, or flat files such
          as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception,
          or troubleshooting logs) must all be protected.

          This requirement does not preclude the use of temporary files containing cleartext PAN
          while encrypting and decrypting PAN.

          This requirement is considered a best practice until 31 March 2025, after which it will be
          required and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 23

--- page 33 ---

PCI DSS Requirement                          Expected Testing                                    Response*
                                                                                          (Check one response for each requirement)
                                                                                    In       In Place    In Place with    Not        Not      Not in
                                                                                   Place    with CCW     Remediation   Applicable  Tested    Place

3.5.1.2   If disk-level or partition-level encryption (rather than file-,   •  Observe encryption        □        □           □            □         □        □
          column-, or field-level database encryption) is used to              processes.
          render PAN unreadable, it is implemented only as               •  Examine configurations
          follows:                                                           and/or vendor
          •  On removable electronic media.                                 documentation.
             OR                                                          •  Observe encryption
          •  If used for non-removable electronic media, PAN is             processes.
             also rendered unreadable via another mechanism
             that meets Requirement 3.5.1.

          Applicability Notes

          While disk encryption may still be present on these types of devices, it cannot be the only
          mechanism used to protect PAN stored on those systems. Any stored PAN must also be
          rendered unreadable per Requirement 3.5.1—for example, through truncation or a data-
          level encryption mechanism. Full disk encryption helps to protect data in the event of
          physical loss of a disk and therefore its use is appropriate only for removable electronic
          media storage devices.
          Media that is part of a data center architecture (for example, hot-swappable drives, bulk
          tape-backups) is considered non-removable electronic media to which Requirement 3.5.1
          applies.
          Disk or partition encryption implementations must also meet all other PCI DSS encryption
          and key-management requirements.
          This requirement is a best practice until 31 March 2025, after which it will be required and
          must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                          Page 24

--- page 34 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                          (Check one response for each requirement)
                                                                                    In       In Place    In Place with    Not        Not      Not in
                                                                                   Place    with CCW    Remediation   Applicable  Tested    Place

3.5.1.3   If disk-level or partition-level encryption is used (rather        •  Examine system           □         □           □            □         □        □
          than file-, column-, or field--level database encryption) to          configurations.
          render PAN unreadable, it is managed as follows:                   •  Observe the
          •  Logical access is managed separately and                           authentication process.
             independently of native operating system                        •  Examine files containing
             authentication and access control mechanisms.                      authentication factors.
          •  Decryption keys are not associated with user                    •  Interview personnel.
             accounts.
          •  Authentication factors (passwords, passphrases, or
             cryptographic keys) that allow access to unencrypted
             data are stored securely.

          Applicability Notes

          Disk or partition encryption implementations must also meet all other PCI DSS encryption
          and key-management requirements.

3.6 Cryptographic keys used to protect stored account data are secured.

3.6.1     Procedures are defined and implemented to protect                  •  Examine documented       □         □           □            □         □        □
          cryptographic keys used to protect stored account data                key-management policies
          against disclosure and misuse that include:                           and procedures.
          •  Access to keys is restricted to the fewest number of
             custodians necessary.
          •  Key-encrypting keys are at least as strong as the
             data-encrypting keys they protect.
          •  Key-encrypting keys are stored separately from data-
             encrypting keys.
          •  Keys are stored securely in the fewest possible
             locations and forms.

          Applicability Notes

          This requirement applies to keys used to encrypt stored account data and to key-
          encrypting keys used to protect data-encrypting keys.
          The requirement to protect keys used to protect stored account data from disclosure and
          misuse applies to both data-encrypting keys and key-encrypting keys. Because one key-
          encrypting key may grant access to many data-encrypting keys, the key-encrypting keys
          require strong protection measures.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 25

--- page 35 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In      In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

3.6.1.1   Additional requirement for service providers only

3.6.1.2   Secret and private keys used to encrypt/decrypt stored        •  Examine documented        □        □           □            □         □        □
          account data are stored in one (or more) of the following        procedures.
          forms at all times:                                           •  Examine system
          •  Encrypted with a key-encrypting key that is at least         configurations and key
             as strong as the data-encrypting key, and that is            storage locations,
             stored separately from the data-encrypting key.              including for key-
          •  Within a secure cryptographic device (SCD), such as         encrypting keys.
             a hardware security module (HSM) or PTS-approved
             point-of-interaction device.
          •  As at least two full-length key components or key
             shares, in accordance with an industry-accepted
             method.

          Applicability Notes

          It is not required that public keys be stored in one of these forms.
          Cryptographic keys stored as part of a key-management system (KMS) that employs
          SCDs are acceptable.
          A cryptographic key that is split into two parts does not meet this requirement. Secret or
          private keys stored as key components or key shares must be generated via one of the
          following:
          •  Using an approved random number generator and within an SCD,
             OR
          •  According to ISO 19592 or equivalent industry standard for generation of secret key
             shares.

3.6.1.3   Access to cleartext cryptographic key components is          •  Examine user access        □        □           □            □         □        □
          restricted to the fewest number of custodians necessary.        lists.

3.6.1.4   Cryptographic keys are stored in the fewest possible         •  Examine key storage        □        □           □            □         □        □
          locations.                                                       locations.
                                                                        •  Observe processes.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 26

--- page 36 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with    Not         Not      Not in
                                              Place   with CCW    Remediation      Applicable  Tested   Place

3.7 Where cryptography is used to protect stored account data, key-management processes and procedures covering all aspects of the key lifecycle are defined and implemented.

3.7.1   Key-management policies and procedures are          •  Examine documented           □    □    □    □    □    □
        implemented to include generation of strong            key-management policies
        cryptographic keys used to protect stored account data.  and procedures.
                                                            •  Observe the method for
                                                               generating keys.

3.7.2   Key-management policies and procedures are          •  Examine documented           □    □    □    □    □    □
        implemented to include secure distribution of          key-management policies
        cryptographic keys used to protect stored account data.  and procedures.
                                                            •  Observe the method for
                                                               distributing keys.

3.7.3   Key-management policies and procedures are          •  Examine documented           □    □    □    □    □    □
        implemented to include secure storage of cryptographic  key-management policies
        keys used to protect stored account data.              and procedures.
                                                            •  Observe the method for
                                                               storing keys.

3.7.4   Key-management policies and procedures are          •  Examine documented           □    □    □    □    □    □
        implemented for cryptographic key changes for keys that  key-management policies
        have reached the end of their cryptoperiod, as defined  and procedures.
        by the associated application vendor or key owner, and  •  Interview personnel.
        based on industry best practices and guidelines,    •  Observe key storage
        including the following:                               locations.
        •  A defined cryptoperiod for each key type in use.
        •  A process for key changes at the end of the defined
           cryptoperiod.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                         Page 27

--- page 37 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

3.7.5   Key-management policies procedures are implemented    •  Examine documented          □       □           □               □           □        □
        to include the retirement, replacement, or destruction of  key-management policies
        keys used to protect stored account data, as deemed       and procedures.
        necessary when:                                        •  Interview personnel.
        •  The key has reached the end of its defined
           cryptoperiod.
        •  The integrity of the key has been weakened,
           including when personnel with knowledge of a
           cleartext key component leaves the company, or the
           role for which the key component was known.
        •  The key is suspected of or known to be
           compromised.
        Retired or replaced keys are not used for encryption
        operations.

        Applicability Notes

        If retired or replaced cryptographic keys need to be retained, these keys must be securely
        archived (for example, by using a key-encryption key).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 28

--- page 38 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not          Not      Not in
                                              Place   with CCW    Remediation     Applicable   Tested   Place

3.7.6   Where manual cleartext cryptographic key-management    • Examine documented          □   □   □   □   □   □
        operations are performed by personnel, key-              key-management policies
        management policies and procedures are implemented       and procedures.
        include managing these operations using split           • Interview personnel.
        knowledge and dual control.                            • Observe processes.

        Applicability Notes

        This control is applicable for manual key-management operations or where key
        management is not controlled by the encryption product.
        A cryptographic key that is simply split into two parts does not meet this requirement.
        Secret or private keys stored as key components or key shares must be generated via
        one of the following:
        •   Using an approved random number generator and within a secure cryptographic
            device (SCD), such as a hardware security module (HSM) or PTS-approved point-of-
            interaction device,
            OR
        •   According to ISO 19592 or equivalent industry standard for generation of secret key
            shares.

3.7.7   Key-management policies and procedures are             • Examine documented          □   □   □   □   □   □
        implemented to include the prevention of unauthorized    key-management policies
        substitution of cryptographic keys.                      and procedures.
                                                               • Interview personnel.
                                                               • Observe processes.

3.7.8   Key-management policies and procedures are             • Examine documented          □   □   □   □   □   □
        implemented to include that cryptographic key            key-management policies
        custodians formally acknowledge (in writing or           and procedures.
        electronically) that they understand and accept their key- • Review documentation or
        custodian responsibilities.                               other evidence of key
                                                                 custodian
                                                                 acknowledgments.

3.7.9   Additional requirement for service providers only


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                         Page 29

--- page 39 ---

Requirement 4: Protect Cardholder Data with Strong Cryptography During Transmission Over Open, Public Networks

                                                                                          Response♦
                                                                                          (Check one response for each requirement)
     PCI DSS Requirement                          Expected Testing              In        In Place      In Place with    Not          Not        Not in
                                                                                Place     with CCW      Remediation      Applicable   Tested     Place

4.1 Processes and mechanisms for protecting cardholder data with strong cryptography during transmission over open, public networks are defined and documented.

4.1.1   All security policies and operational procedures that    •  Examine documentation.    □    □    □    □    □    □
        are identified in Requirement 4 are:                     •  Interview personnel.
        •  Documented.
        •  Kept up to date.
        •  In use.
        •  Known to all affected parties.

4.1.2   Roles and responsibilities for performing activities in  •  Examine documentation.    □    □    □    □    □    □
        Requirement 4 are documented, assigned, and              •  Interview responsible
        understood.                                                 personnel

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 30

--- page 40 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

4.2 PAN is protected with strong cryptography during transmission.

4.2.1   Strong cryptography and security protocols are
        implemented as follows to safeguard PAN during
        transmission over open, public networks:

      • Only trusted keys and certificates are accepted.        • Examine documented          □   □   □   □   □   □
                                                                  policies and procedures.
      • Certificates used to safeguard PAN during              • Interview personnel.         □   □   □   □   □   □
        transmission over open, public networks are            • Examine system
        confirmed as valid and are not expired or revoked.       configurations.
        This bullet is a best practice until its effective date; • Examine cardholder data
        refer to Applicability Notes below for details.          transmissions.
      • The protocol in use supports only secure versions      • Examine keys and             □   □   □   □   □   □
        or configurations and does not support fallback to,      certificates.
        or use of insecure versions, algorithms, key sizes,
        or implementations.

      • The encryption strength is appropriate for the                                        □   □   □   □   □   □
        encryption methodology in use.

        Applicability Notes

        There could be occurrences where an entity receives cardholder data unsolicited via an
        insecure communication channel that was not intended for the purpose of receiving
        sensitive data. In this situation, the entity can choose to either include the channel in the
        scope of their CDE and secure it according to PCI DSS or implement measures to
        prevent the channel from being used for cardholder data.

        A self-signed certificate may also be acceptable if the certificate is issued by an internal
        CA within the organization, the certificate's author is confirmed, and the certificate is
        verified—for example, via hash or signature—and has not expired. Note that self-signed
        certificates where the Distinguished Name (DN) field in the "issued by" and "issued to"
        field is the same are not acceptable.

        The bullet above (for confirming that certificates used to safeguard PAN during
        transmission over open, public networks are valid and are not expired or revoked) is a
        best practice until 31 March 2025, after which it will be required as part of Requirement
        4.2.1 and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                               Page 31

--- page 41 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                                        In      In Place    In Place with    Not         Not      Not in
                                                       Place    with CCW    Remediation   Applicable   Tested    Place

4.2.1.1   An inventory of the entity's trusted keys and          •  Examine documented           □       □           □            □           □        □
          certificates used to protect PAN during transmission is    policies and procedures.
          maintained.                                            •  Examine the inventory of
                                                                    trusted keys and certificates.

          Applicability Notes

          This requirement is a best practice until 31 March 2025, after which it will be required and
          must be fully considered during a PCI DSS assessment.

4.2.1.2   Wireless networks transmitting PAN or connected to     •  Examine system                □       □           □            □           □        □
          the CDE use industry best practices to implement           configurations.
          strong cryptography for authentication and
          transmission.

4.2.2     PAN is secured with strong cryptography whenever it    •  Examine documented            □       □           □            □           □        □
          is sent via end-user messaging technologies.               policies and procedures.
                                                                 •  Examine system
                                                                    configurations and vendor
                                                                    documentation.

          Applicability Notes

          This requirement also applies if a customer, or other third-party, requests that PAN is
          sent to them via end-user messaging technologies.
          There could be occurrences where an entity receives unsolicited cardholder data via an
          insecure communication channel that was not intended for transmissions of sensitive
          data. In this situation, the entity can choose to either include the channel in the scope of
          their CDE and secure it according to PCI DSS or delete the cardholder data and
          implement measures to prevent the channel from being used for cardholder data.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 32

--- page 42 ---

Maintain a Vulnerability Management Program

Requirement 5: Protect All Systems and Networks from Malicious Software

                                                                                          Response♦
                                                                                          (Check one response for each requirement)
         PCI DSS Requirement                              Expected Testing          In       In Place    In Place with    Not       Not      Not in
                                                                                   Place    with CCW    Remediation   Applicable  Tested   Place

5.1 Processes and mechanisms for protecting all systems and networks from malicious software are defined and understood.

5.1.1    All security policies and operational procedures that    • Examine documentation.    □    □    □    □    □    □
         are identified in Requirement 5 are:                    • Interview personnel.
         • Documented.
         • Kept up to date.
         • In use.
         • Known to all affected parties.

5.1.2    Roles and responsibilities for performing activities in  • Examine documentation.    □    □    □    □    □    □
         Requirement 5 are documented, assigned, and             • Interview responsible
         understood.                                               personnel.
         New requirement - effective immediately

5.2 Malicious software (malware) is prevented, or detected and addressed.

5.2.1    An anti-malware solution(s) is deployed on all system   • Examine system            □    □    □    □    □    □
         components, except for those system components            components.
         identified in periodic evaluations per Requirement      • Examine the periodic
         5.2.3 that concludes the system components are not        evaluations.
         at risk from malware.

5.2.2    The deployed anti-malware solution(s):                  • Examine vendor            □    □    □    □    □    □
         • Detects all known types of malware.                     documentation.
         • Removes, blocks, or contains all known types of       • Examine system
           malware.                                                configurations.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                              Page 33

--- page 43 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

5.2.3    Any system components that are not at risk for      •  Examine documented           □       □           □               □           □        □
         malware are evaluated periodically to include the      policies and procedures.
         following:                                          •  Interview personnel.
         •  A documented list of all system components not  •  Examine the list of system
            at risk for malware.                               components not at risk for
         •  Identification and evaluation of evolving          malware and compare
            malware threats for those system components.       against the system
         •  Confirmation whether such system components        components without an anti-
            continue to not require anti-malware protection.   malware solution deployed.

         Applicability Notes

         System components covered by this requirement are those for which there is no anti-
         malware solution deployed per Requirement 5.2.1.

5.2.3.1  The frequency of periodic evaluations of system    •  Examine the targeted risk     □       □           □               □           □        □
         components identified as not at risk for malware      analysis.
         is defined in the entity's targeted risk analysis, •  Examine documented
         which is performed according to all elements          results of periodic
         specified in Requirement 12.3.1.                      evaluations.
                                                            •  Interview personnel.

         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required and
         must be fully considered during a PCI DSS assessment.

5.3 Anti-malware mechanisms and processes are active, maintained, and monitored.

5.3.1    The anti-malware solution(s) is kept current via   •  Examine anti-malware          □       □           □               □           □        □
         automatic updates.                                    solution(s) configurations,
                                                               including any master
                                                               installation.
                                                            •  Examine system
                                                               components and logs.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 34

--- page 44 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

5.3.2   The anti-malware solution(s):                    • Examine anti-malware          □       □           □               □           □        □
        • Performs periodic scans and active or real-time  solution(s) configurations,
          scans                                            including any master
          OR                                              installation.
        • Performs continuous behavioral analysis of    • Examine system
          systems or processes.                           components.
                                                        • Examine logs and scan
                                                          results.

5.3.2.1 If periodic malware scans are performed to meet  • Examine the targeted risk     □       □           □               □           □        □
        Requirement 5.3.2, the frequency of scans is defined  analysis.
        in the entity's targeted risk analysis, which is  • Examine documented
        performed according to all elements specified in    results of periodic malware
        Requirement 12.3.1.                               scans.
                                                        • Interview personnel.

        Applicability Notes

        This requirement applies to entities conducting periodic malware scans to meet
        Requirement 5.3.2.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

5.3.3   For removable electronic media, the anti-malware  • Examine anti-malware         □       □           □               □           □        □
        solution(s):                                       solution(s) configurations.
        • Performs automatic scans of when the media is  • Examine system
          inserted, connected, or logically mounted,       components with removable
          OR                                              electronic media.
        • Performs continuous behavioral analysis of    • Examine logs and scan
          systems or processes when the media is inserted,  results.
          connected, or logically mounted.

        Applicability Notes

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 35

--- page 45 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In       In Place     In Place with    Not        Not       Not in
                                                                                             Place    with CCW      Remediation   Applicable  Tested     Place

5.3.4   Audit logs for the anti-malware solution(s) are enabled        • Examine anti-malware          □        □           □            □          □         □
        and retained in accordance with Requirement 10.5.1.              solution(s) configurations.

5.3.5   Anti-malware mechanisms cannot be disabled or                  • Examine anti-malware          □        □           □            □          □         □
        altered by users, unless specifically documented, and            configurations.
        authorized by management on a case-by-case basis               • Observe processes.
        for a limited time period.                                      • Interview responsible
                                                                         personnel.

        Applicability Notes

        Anti-malware solutions may be temporarily disabled only if there is a legitimate technical
        need, as authorized by management on a case-by-case basis. If anti-malware protection
        needs to be disabled for a specific purpose, it must be formally authorized. Additional
        security measures may also need to be implemented for the period during which anti-
        malware protection is not active.

5.4 Anti-phishing mechanisms protect users against phishing attacks.

5.4.1   Processes and automated mechanisms are in place to             • Observe implemented           □        □           □            □          □         □
        detect and protect personnel against phishing attacks.           processes.
                                                                       • Examine mechanisms.

        Applicability Notes

        This requirement applies to the automated mechanism. It is not intended that the systems
        and services providing such automated mechanisms (such as e-mail servers) are brought
        into scope for PCI DSS.
        The focus of this requirement is on protecting personnel with access to system
        components in-scope for PCI DSS.
        Meeting this requirement for technical and automated controls to detect and protect
        personnel against phishing is not the same as Requirement 12.6.3.1 for security
        awareness training. Meeting this requirement does not also meet the requirement for
        providing personnel with security awareness training, and vice versa.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 36

--- page 46 ---

Requirement 6: Develop and Maintain Secure Systems and Software

                                                                                    Response♦
                                                                                    (Check one response for each requirement)
         PCI DSS Requirement                          Expected Testing        In Place   In Place    In Place with    Not        Not      Not in
                                                                                         with CCW    Remediation      Applicable Tested   Place

6.1 Processes and mechanisms for developing and maintaining secure systems and software are defined and understood.

6.1.1    All security policies and operational procedures that are    • Examine documentation.    □    □    □    □    □    □
         identified in Requirement 6 are:                            • Interview personnel.
         • Documented.
         • Kept up to date.
         • In use.
         • Known to all affected parties.

6.1.2    Roles and responsibilities for performing activities in      • Examine documentation.    □    □    □    □    □    □
         Requirement 6 are documented, assigned, and understood.     • Interview responsible
                                                                       personnel.

6.2 Bespoke and custom software are developed securely.

6.2.1    Bespoke and custom software are developed securely, as      • Examine documented        □    □    □    □    □    □
         follows:                                                       software development
         • Based on industry standards and/or best practices for       procedures.
           secure development.
         • In accordance with PCI DSS (for example, secure
           authentication and logging).
         • Incorporating consideration of information security issues
           during each stage of the software development lifecycle.

         Applicability Notes

         This applies to all software developed for or by the entity for the entity's own use. This
         includes both bespoke and custom software. This does not apply to third-party software.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                               Page 37

--- page 47 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In Place   In Place   In Place with   Not          Not      Not in
                                                         with CCW   Remediation     Applicable   Tested   Place

6.2.2   Software development personnel working on bespoke and      •  Examine documented        □   □   □   □   □   □
        custom software are trained at least once every 12 months     software development
        as follows:                                                    procedures.
        •  On software security relevant to their job function and  •  Examine training records.
           development languages.                                   •  Interview personnel.
        •  Including secure software design and secure coding
           techniques.
        •  Including, if security testing tools are used, how to use the
           tools for detecting vulnerabilities in software.

        Applicability Notes

        Software development personnel remain knowledgeable about secure development
        practices; software security; and attacks against the languages, frameworks, or applications
        they develop. Personnel are able to access assistance and guidance when required.

6.2.3   Bespoke and custom software is reviewed prior to being     •  Examine documented        □   □   □   □   □   □
        released into production or to customers, to identify and     software development
        correct potential coding vulnerabilities, as follows:         procedures.
        •  Code reviews ensure code is developed according to      •  Interview responsible
           secure coding guidelines.                                  personnel.
        •  Code reviews look for both existing and emerging        •  Examine evidence of
           software vulnerabilities.                                  changes to bespoke and
        •  Appropriate corrections are implemented prior to release.  custom software.

        Applicability Notes

        This requirement for code reviews applies to all bespoke and custom software (both internal
        and public-facing), as part of the system development lifecycle.
        Public-facing web applications are also subject to additional controls, to address ongoing
        threats and vulnerabilities after implementation, as defined at PCI DSS Requirement 6.4.
        Code reviews may be performed using either manual or automated processes, or a
        combination of both.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                               Page 38

--- page 48 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                          (Check one response for each requirement)
                                                                              In Place   In Place   In Place with   Not          Not      Not in
                                                                                         with CCW   Remediation     Applicable   Tested   Place

6.2.3.1   If manual code reviews are performed for bespoke and              • Examine documented        □          □          □          □          □          □
          custom software prior to release to production, code changes        software development
          are:                                                                procedures.
          •  Reviewed by individuals other than the originating code        • Interview responsible
             author, and who are knowledgeable about code-review              personnel.
             techniques and secure coding practices.                        • Examine evidence of
          •  Reviewed and approved by management prior to release.            changes to bespoke and
                                                                              custom software.

          Applicability Notes

          Manual code reviews can be conducted by knowledgeable internal personnel or
          knowledgeable third-party personnel.
          An individual that has been formally granted accountability for release control and who is
          neither the original code author nor the code reviewer fulfills the criteria of being
          management.

6.2.4     Software engineering techniques or other methods are
          defined and in use by software development personnel to
          prevent or mitigate common software attacks and related
          vulnerabilities in bespoke and custom software, including but
          not limited to the following:

          •  Injection attacks, including SQL, LDAP, XPath, or other      • Examine documented          □          □          □          □          □          □
             command, parameter, object, fault, or injection-type flaws.    procedures.
          •  Attacks on data and data structures, including attempts to   • Interview responsible        □          □          □          □          □          □
             manipulate buffers, pointers, input data, or shared data.      software development
          •  Attacks on cryptography usage, including attempts to           personnel.                  □          □          □          □          □          □
             exploit weak, insecure, or inappropriate cryptographic
             implementations, algorithms, cipher suites, or modes of
             operation.
          •  Attacks on business logic, including attempts to abuse or                                  □          □          □          □          □          □
             bypass application features and functionalities through
             the manipulation of APIs, communication protocols and
             channels, client-side functionality, or other
             system/application functions and resources. This includes
             cross-site scripting (XSS) and cross-site request forgery
             (CSRF). (continued)

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 39

--- page 49 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In Place   In Place   In Place with   Not          Not      Not in
                                                         with CCW   Remediation     Applicable   Tested   Place

6.2.4    • Attacks on access control mechanisms, including                          □          □          □          □          □          □
(cont.)    attempts to bypass or abuse identification, authentication,
           or authorization mechanisms, or attempts to exploit
           weaknesses in the implementation of such mechanisms.

         • Attacks via any "high-risk" vulnerabilities identified in the             □          □          □          □          □          □
           vulnerability identification process, as defined in
           Requirement 6.3.1.

         Applicability Notes

         This applies to all software developed for or by the entity for the entity's own use. This
         includes both bespoke and custom software. This does not apply to third-party software.

6.3 Security vulnerabilities are identified and addressed.

6.3.1    Security vulnerabilities are identified and managed as        • Examine policies and    □          □          □          □          □          □
         follows:                                                        procedures.
         • New security vulnerabilities are identified using industry- • Interview responsible
           recognized sources for security vulnerability information,    personnel.
           including alerts from international and national computer   • Examine documentation.
           emergency response teams (CERTs).                          • Observe processes.
         • Vulnerabilities are assigned a risk ranking based on
           industry best practices and consideration of potential
           impact.
         • Risk rankings identify, at a minimum, all vulnerabilities
           considered to be a high-risk or critical to the environment.
         • Vulnerabilities for bespoke and custom, and third-party
           software (for example operating systems and databases)
           are covered.

         Applicability Notes

         This requirement is not achieved by, nor is it the same as, vulnerability scans performed for
         Requirements 11.3.1 and 11.3.2. This requirement is for a process to actively monitor
         industry sources for vulnerability information and for the entity to determine the risk ranking to
         be associated with each vulnerability.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                   Page 40

--- page 50 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In Place   In Place   In Place with   Not          Not      Not in
                                                               with CCW   Remediation     Applicable   Tested   Place

6.3.2   An inventory of bespoke and custom software, and third-    •  Examine documentation.   □   □   □   □   □   □
        party software components incorporated into bespoke and    •  Interview personnel.
        custom software is maintained to facilitate vulnerability and  •
        patch management.

        Applicability Notes

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment

6.3.3   All system components are protected from known             •  Examine policies and      □   □   □   □   □   □
        vulnerabilities by installing applicable security              procedures.
        patches/updates as follows:                                •  Examine system
        •  Critical or high-security patches/updates (identified      components and related
           according to the risk ranking process at Requirement        software.
           6.3.1) are installed within one month of release.       •  Compare list of security
        •  All other applicable security patches/updates are installed    patches installed to
           within an appropriate time frame as determined by the       recent vendor patch lists.
           entity (for example, within three months of release).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                            Page 41

--- page 51 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                          In Place   In Place    In Place with    Not        Not      Not in
                                                                                                     with CCW    Remediation   Applicable  Tested    Place

6.4 Public-facing web applications are protected against attacks.

6.4.1   For public-facing web applications, new threats and              • Examine documented          □          □           □            □          □        □
        vulnerabilities are addressed on an ongoing basis and these        processes.
        applications are protected against known attacks as follows:     • Interview personnel.
        •  Reviewing public-facing web applications via manual or        • Examine records of
           automated application vulnerability security assessment          application security
           tools or methods as follows:                                    assessments
           –   At least once every 12 months and after                  • Examine the system
               significant changes.                                        configuration settings and
           –   By an entity that specializes in application                audit logs.
               security.
           –   Including, at a minimum, all common software
               attacks in Requirement 6.2.4.
           –   All vulnerabilities are ranked in accordance with
               Requirement 6.3.1.
           –   All vulnerabilities are corrected.
           –   The application is re-evaluated after the
               corrections

        OR
        •  Installing an automated technical solution(s) that
           continually detects and prevents web-based attacks as
           follows:
           –   Installed in front of public-facing web applications
               to detect and prevent web-based attacks.
           –   Actively running and up to date as applicable.
           –   Generating audit logs.
           –   Configured to either block web-based attacks or
               generate an alert that is immediately investigated.

        Applicability Notes

        This assessment is not the same as the vulnerability scans performed for Requirement
        11.3.1 and 11.3.2.
        This requirement will be superseded by Requirement 6.4.2 after 31 March 2025 when
        Requirement 6.4.2 becomes effective.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 42

--- page 52 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                          In Place   In Place    In Place with    Not          Not       Not in
                                                                                                     with CCW    Remediation      Applicable   Tested    Place

6.4.2   For public-facing web applications, an automated technical          • Examine the system          □          □               □            □          □         □
        solution is deployed that continually detects and prevents             configuration settings.
        web-based attacks, with at least the following:                     • Examine audit logs.
        • Is installed in front of public-facing web applications and       • Interview responsible
          is configured to detect and prevent web-based attacks.              personnel.
        • Actively running and up to date as applicable.
        • Generating audit logs.
        • Configured to either block web-based attacks or generate
          an alert that is immediately investigated.

        Applicability Notes

        This new requirement will replace Requirement 6.4.1 once its effective date is reached.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

6.4.3   All payment page scripts that are loaded and executed in the        • Examine policies and        □          □               □            □          □         □
        consumer's browser are managed as follows:                            procedures.
        • A method is implemented to confirm that each script is            • Interview responsible
          authorized.                                                          personnel.
        • A method is implemented to assure the integrity of each           • Examine inventory
          script.                                                              records.
        • An inventory of all scripts is maintained with written            • Examine system
          justification as to why each is necessary.                          configurations.

        Applicability Notes

        This requirement applies to all scripts loaded from the entity's environment and scripts
        loaded from third and fourth parties.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                    Page 43

--- page 53 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In Place   In Place   In Place with   Not         Not      Not in
                                                               with CCW   Remediation     Applicable  Tested   Place

6.5 Changes to all system components are managed securely.

6.5.1   Changes to all system components in the production        •  Examine documented        □    □    □    □    □    □
        environment are made according to established procedures      change control
        that include:                                                 procedures.
        •  Reason for, and description of, the change.            •  Examine recent changes
        •  Documentation of security impact.                         to system components
        •  Documented change approval by authorized parties.         and trace changes to
        •  Testing to verify that the change does not adversely      change control
           impact system security.                                   documentation.
        •  For bespoke and custom software changes, all updates   •  Examine change control
           are tested for compliance with Requirement 6.2.4 before   documentation.
           being deployed into production.
        •  Procedures to address failures and return to a secure
           state.

6.5.2   Upon completion of a significant change, all applicable PCI   •  Examine documentation     □    □    □    □    □    □
        DSS requirements are confirmed to be in place on all new or      for significant changes.
        changed systems and networks, and documentation is         •  Interview personnel.
        updated as applicable.                                     •  Observe the affected
                                                                      systems/networks.

        Applicability Notes

        These significant changes should also be captured and reflected in the entity's annual PCI
        DSS scope confirmation activity per Requirement 12.5.2.

6.5.3   Pre-production environments are separated from production  •  Examine policies and       □    □    □    □    □    □
        environments and the separation is enforced with access       procedures.
        controls.                                                  •  Examine network
                                                                      documentation and
                                                                      configurations of network
                                                                      security controls.
                                                                   •  Examine access control
                                                                      settings.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                            Page 44

--- page 54 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                          In Place   In Place   In Place with   Not          Not      Not in
                                                                                     with CCW   Remediation     Applicable   Tested   Place

6.5.4   Roles and functions are separated between production and        • Examine policies and      □          □          □               □            □        □
        pre-production environments to provide accountability such        procedures.
        that only reviewed and approved changes are deployed.           • Observe processes.
                                                                        • Interview personnel.

        Applicability Notes

        In environments with limited personnel where individuals perform multiple roles or functions,
        this same goal can be achieved with additional procedural controls that provide
        accountability. For example, a developer may also be an administrator that uses an
        administrator-level account with elevated privileges in the development environment and, for
        their developer role, they use a separate account with user-level access to the production
        environment.

6.5.5   Live PANs are not used in pre-production environments,          • Examine policies and      □          □          □               □            □        □
        except where those environments are included in the CDE           procedures.
        and protected in accordance with all applicable PCI DSS         • Observe testing
        requirements.                                                      processes.
                                                                        • Interview personnel.
                                                                        • Examine pre-production
                                                                          test data.

6.5.6   Test data and test accounts are removed from system             • Examine policies and      □          □          □               □            □        □
        components before the system goes into production.                procedures.
                                                                        • Observe testing
                                                                          processes for both off-
                                                                          the-shelf software and in-
                                                                          house applications.
                                                                        • Interview personnel.
                                                                        • Examine data and
                                                                          accounts for recently
                                                                          installed or updated off-
                                                                          the-shelf software and in-
                                                                          house applications.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                            April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                 Page 45

--- page 55 ---

Implement Strong Access Control Measures

Requirement 7: Restrict Access to System Components and Cardholder Data by Business Need to Know

                                                                                          Response♦
                                                                                (Check one response for each requirement)
         PCI DSS Requirement                          Expected Testing          In      In Place    In Place with    Not        Not      Not in
                                                                               Place    with CCW    Remediation   Applicable  Tested    Place

7.1 Processes and mechanisms for restricting access to system components and cardholder data by business need to know are defined and understood.

7.1.1   All security policies and operational procedures that    •  Examine documentation.      □       □           □            □         □        □
        are identified in Requirement 7 are:                    •  Interview personnel.
        •  Documented.
        •  Kept up to date.
        •  In use.
        •  Known to all affected parties.

7.1.2   Roles and responsibilities for performing activities in  •  Examine documentation.      □       □           □            □         □        □
        Requirement 7 are documented, assigned, and             •  Interview responsible
        understood.                                                personnel.

7.2 Access to system components and data is appropriately defined and assigned.

7.2.1   An access control model is defined and includes         •  Examine documented           □       □           □            □         □        □
        granting access as follows:                                policies and procedures.
        •  Appropriate access depending on the entity's         •  Interview personnel.
           business and access needs.                           •  Examine access control
        •  Access to system components and data                    model settings.
           resources that is based on users' job
           classification and functions.
        •  The least privileges required (for example, user,
           administrator) to perform a job function.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 46

--- page 56 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place     In Place with   Not        Not      Not in
                                              Place   with CCW     Remediation     Applicable Tested   Place

7.2.2   Access is assigned to users, including privileged   •   Examine policies and        □       □            □               □          □        □
        users, based on:                                        procedures.
        •   Job classification and function.                •   Examine user access
        •   Least privileges necessary to perform job           settings, including for
            responsibilities.                                   privileged users.
                                                            •   Interview responsible
                                                                management personnel.
                                                            •   Interview personnel
                                                                responsible for assigning
                                                                access.

7.2.3   Required privileges are approved by authorized      •   Examine policies and        □       □            □               □          □        □
        personnel.                                              procedures.
                                                            •   Examine user IDs and
                                                                assigned privileges.
                                                            •   Examine documented
                                                                approvals.

7.2.4   All user accounts and related access privileges,    •   Examine policies and        □       □            □               □          □        □
        including third-party/vendor accounts, are reviewed     procedures.
        as follows:                                         •   Interview responsible
        •   At least once every six months.                     personnel.
        •   To ensure user accounts and access remain       •   Examine documented
            appropriate based on job function.                  results of periodic reviews of
        •   Any inappropriate access is addressed.              user accounts.
        •   Management acknowledges that access remains
            appropriate.

        Applicability Notes

        This requirement applies to all user accounts and related access privileges, including
        those used by personnel and third parties/vendors, and accounts used to access third-
        party cloud services.
        See Requirements 7.2.5 and 7.2.5.1 and 8.6.1 through 8.6.3 for controls for application
        and system accounts.
        This requirement is a best practice until 31 March 2025, after which it will be required
        and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 47

--- page 57 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place     In Place with   Not        Not      Not in
                                              Place   with CCW     Remediation     Applicable Tested   Place

7.2.5    All application and system accounts and related    • Examine policies and         □       □            □               □          □        □
         access privileges are assigned and managed as        procedures.
         follows:                                           • Examine privileges
         • Based on the least privileges necessary for the    associated with system and
           operability of the system or application.          application accounts.
         • Access is limited to the systems, applications, or • Interview responsible
           processes that specifically require their use.      personnel.

         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required
         and must be fully considered during a PCI DSS assessment.

7.2.5.1  All access by application and system accounts and  • Examine policies and         □       □            □               □          □        □
         related access privileges are reviewed as follows:   procedures.
         • Periodically (at the frequency defined in the    • Examine the targeted risk
           entity's targeted risk analysis, which is performed  analysis.
           according to all elements specified in           • Interview responsible
           Requirement 12.3.1).                               personnel.
         • The application/system access remains            • Examine documented
           appropriate for the function being performed.      results of periodic reviews of
         • Any inappropriate access is addressed.             system and application
         • Management acknowledges that access remains        accounts and related
           appropriate.                                       privileges.

         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required
         and must be fully considered during a PCI DSS assessment


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 48

--- page 58 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                        (Check one response for each requirement)
                                                                                In       In Place      In Place with    Not          Not        Not in
                                                                                Place    with CCW      Remediation      Applicable   Tested     Place

7.2.6   All user access to query repositories of stored          •  Examine policies and          □        □              □              □            □          □
        cardholder data is restricted as follows:                   procedures.
        •  Via applications or other programmatic methods,       •  Interview personnel.
           with access and allowed actions based on user         •  Examine configuration
           roles and least privileges.                              settings for querying
        •  Only the responsible administrator(s) can directly       repositories of stored
           access or query repositories of stored CHD.              cardholder data.

        Applicability Notes

        This requirement applies to controls for user access to query repositories of stored
        cardholder data.
        See Requirements 7.2.5 and 7.2.5.1 and 8.6.1 through 8.6.3 for controls for application
        and system accounts.

7.3 Access to system components and data is managed via an access control system(s).

7.3.1   An access control system(s) is in place that restricts   •  Examine vendor                □        □              □              □            □          □
        access based on a user's need to know and covers            documentation.
        all system components.                                   •  Examine configuration
                                                                    settings.

7.3.2   The access control system(s) is configured to            •  Examine vendor                □        □              □              □            □          □
        enforce permissions assigned to individuals,                documentation.
        applications, and systems based on job classification    •  Examine configuration
        and function.                                               settings.

7.3.3   The access control system(s) is set to "deny all" by     •  Examine vendor                □        □              □              □            □          □
        default.                                                    documentation.
                                                                 •  Examine configuration
                                                                    settings.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                  Page 49

--- page 59 ---

Requirement 8: Identify Users and Authenticate Access to System Components

                                                                                    Response*
                                                                               (Check one response for each requirement)
         PCI DSS Requirement                          Expected Testing        In      In Place    In Place with    Not       Not     Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested   Place

8.1 Processes and mechanisms for identifying users and authenticating access to system components are defined and understood.

8.1.1   All security policies and operational procedures that are   •  Examine documentation.    □       □           □           □       □       □
        identified in Requirement 8 are:                            •  Interview personnel.
        •  Documented.
        •  Kept up to date.
        •  In use.
        •  Known to all affected parties.

8.1.2   Roles and responsibilities for performing activities in     •  Examine documentation.    □       □           □           □       □       □
        Requirement 8 are documented, assigned, and                 •  Interview responsible
        understood.                                                    personnel.

8.2 User identification and related accounts for users and administrators are strictly managed throughout an account's lifecycle.

8.2.1   All users are assigned a unique ID before access to         •  Interview responsible     □       □           □           □       □       □
        system components or cardholder data is allowed.               personnel.
                                                                    •  Examine audit logs and
                                                                       other evidence.

        Applicability Notes

        This requirement is not intended to apply to user accounts within point-of-sale terminals
        that have access to only one card number at a time to facilitate a single transaction (such
        as IDs used by cashiers on point-of-sale terminals).

Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                   Page 50

--- page 60 ---

PCI DSS Requirement                                Expected Testing                          Response*
                                                                                    (Check one response for each requirement)
                                                                               In       In Place    In Place with    Not        Not      Not in
                                                                             Place     with CCW     Remediation   Applicable  Tested    Place

8.2.2   Group, shared, or generic accounts, or other shared          •  Examine user account lists      □         □            □          □         □        □
        authentication credentials are only used when                   on system components and
        necessary on an exception basis, and are managed as             applicable documentation.
        follows:                                                      •  Examine authentication
        •  Account use is prevented unless needed for an                policies and procedures.
           exceptional circumstance.                                  •  Interview system
        •  Use is limited to the time needed for the exceptional        administrators.
           circumstance.
        •  Business justification for use is documented.
        •  Use is explicitly approved by management.
        •  Individual user identity is confirmed before access to
           an account is granted.
        •  Every action taken is attributable to an individual
           user.

        Applicability Notes

        This requirement is not intended to apply to user accounts within point-of-sale terminals
        that have access to only one card number at a time to facilitate a single transaction (such
        as IDs used by cashiers on point-of-sale terminals).

8.2.3   Additional requirement for service providers only

8.2.4   Addition, deletion, and modification of user IDs,            •  Examine documented              □         □            □          □         □        □
        authentication factors, and other identifier objects are        authorizations across
        managed as follows:                                             various phases of the
        •  Authorized with the appropriate approval.                   account lifecycle (additions,
        •  Implemented with only the privileges specified on           modifications, and
           the documented approval.                                    deletions).
                                                                      •  Examine system settings.

        Applicability Notes

        This requirement applies to all user accounts, including employees, contractors,
        consultants, temporary workers, and third-party vendors.


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                              Page 51

--- page 61 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

8.2.5   Access for terminated users is immediately revoked.   •  Examine information        □   □   □   □   □   □
                                                                 sources for terminated
                                                                 users.
                                                              •  Review current user access
                                                                 lists.
                                                              •  Interview responsible
                                                                 personnel.

8.2.6   Inactive user accounts are removed or disabled within    •  Examine user accounts and   □   □   □   □   □   □
        90 days of inactivity.                                      last logon information.
                                                                 •  Interview responsible
                                                                    personnel.

8.2.7   Accounts used by third parties to access, support, or   •  Interview responsible       □   □   □   □   □   □
        maintain system components via remote access are            personnel.
        managed as follows:                                      •  Examine documentation for
        •  Enabled only during the time period needed and           managing accounts.
           disabled when not in use.                             •  Examine evidence.
        •  Use is monitored for unexpected activity.

8.2.8   If a user session has been idle for more than 15        •  Examine system              □   □   □   □   □   □
        minutes, the user is required to re-authenticate to re-    configuration settings.
        activate the terminal or session.

        Applicability Notes

        This requirement is not intended to apply to user accounts on point-of-sale terminals that
        have access to only one card number at a time to facilitate a single transaction (such as
        IDs used by cashiers on point-of-sale terminals).
        This requirement is not meant to prevent legitimate activities from being performed while
        the console/PC is unattended.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                              Page 52

--- page 62 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not        Not       Not in
                                                    Place   with CCW     Remediation      Applicable Tested    Place

8.3 Strong authentication for users and administrators is established and managed.

8.3.1   All user access to system components for users and       • Examine documentation              □       □        □               □          □         □
        administrators is authenticated via at least one of the    describing the authentication
        following authentication factors:                          factor(s) used.
        • Something you know, such as a password or             • For each type of
          passphrase.                                              authentication factor used
        • Something you have, such as a token device or           with each type of system
          smart card.                                             component, observe the
        • Something you are, such as a biometric element.        authentication process.

        Applicability Notes

        This requirement is not intended to apply to user accounts on point-of-sale terminals that
        have access to only one card number at a time to facilitate a single transaction (such as
        IDs used by cashiers on point-of-sale terminals).
        This requirement does not supersede multi-factor authentication (MFA) requirements but
        applies to those in-scope systems not otherwise subject to MFA requirements.
        A digital certificate is a valid option for "something you have" if it is unique for a particular
        user

8.3.2   Strong cryptography is used to render all authentication  • Examine vendor                    □       □        □               □          □         □
        factors unreadable during transmission and storage on       documentation
        all system components.                                   • Examine system
                                                                   configuration settings.
                                                                 • Examine repositories of
                                                                   authentication factors.
                                                                 • Examine data
                                                                   transmissions.

8.3.3   User identity is verified before modifying any           • Examine procedures for             □       □        □               □          □         □
        authentication factor.                                     modifying authentication
                                                                   factors.
                                                                 • Observe security personnel.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 53

--- page 63 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

8.3.4   Invalid authentication attempts are limited by:          •  Examine system            □       □           □               □           □        □
        •  Locking out the user ID after not more than 10           configuration settings.
           attempts.
        •  Setting the lockout duration to a minimum of 30
           minutes or until the user's identity is confirmed.

        Applicability Notes

        This requirement is not intended to apply to user accounts within point-of-sale terminals
        that have access to only one card number at a time to facilitate a single transaction (such
        as IDs used by cashiers on point-of-sale terminals).

8.3.5   If passwords/passphrases are used as authentication       •  Examine procedures for   □       □           □               □           □        □
        factors to meet Requirement 8.3.1, they are set and          setting and resetting
        reset for each user as follows:                              passwords/passphrases.
        •  Set to a unique value for first-time use and upon      •  Observe security personnel.
           reset.
        •  Forced to be changed immediately after the first
           use.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 54

--- page 64 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

8.3.6   If passwords/passphrases are used as authentication   •   Examine system            □       □           □               □           □        □
        factors to meet Requirement 8.3.1, they meet the         configuration settings.
        following minimum level of complexity:
        •   A minimum length of 12 characters (or IF the system
            does not support 12 characters, a minimum length
            of eight characters).
        •   Contain both numeric and alphabetic characters.

        Applicability Notes

        This requirement is not intended to apply to:
        •   User accounts on point-of-sale terminals that have access to only one card number at a
            time to facilitate a single transaction (such as IDs used by cashiers on point-of-sale
            terminals).
        •   Application or system accounts, which are governed by requirements in section 8.6.
        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.
        Until 31 March 2025, passwords must be a minimum length of seven characters in
        accordance with PCI DSS v3.2.1 Requirement 8.2.3.

8.3.7   Individuals are not allowed to submit a new            •   Examine system            □       □           □               □           □        □
        password/passphrase that is the same as any of the         configuration settings.
        last four passwords/passphrases used.

        Applicability Notes

        This requirement is not intended to apply to user accounts within point-of-sale terminals
        that have access to only one card number at a time to facilitate a single transaction (such
        as IDs used by cashiers on point-of-sale terminals).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 55

--- page 65 ---

PCI DSS Requirement   Expected Testing   Response*
(Check one response for each requirement)
In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

8.3.8   Authentication policies and procedures are documented and communicated to all users including:
   • Guidance on selecting strong authentication factors.
   • Guidance for how users should protect their authentication factors.
   • Instructions not to reuse previously used passwords/passphrases.
   • Instructions to change passwords/passphrases if there is any suspicion or knowledge that the password/passphrases have been compromised and how to report the incident.
   • Examine procedures.
   • Interview personnel.
   • Review authentication policies and procedures that are distributed to users.
   • Interview users.
   □   □   □   □   □   □

8.3.9   If passwords/passphrases are used as the only authentication factor for user access (i.e., in any single-factor authentication implementation) then either:
   • Passwords/passphrases are changed at least once every 90 days,
      OR
   • The security posture of accounts is dynamically analyzed, and real-time access to resources is automatically determined accordingly.

   Applicability Notes

   This requirement applies to in-scope system components that are not in the CDE because these components are not subject to MFA requirements.
   This requirement is not intended to apply to user accounts on point-of-sale terminals that have access to only one card number at a time to facilitate a single transaction (such as IDs used by cashiers on point-of-sale terminals).
   This requirement does not apply to service providers' customer accounts but does apply to accounts for service provider personnel.
   • Inspect system configuration settings.
   □   □   □   □   □   □

8.3.10   Additional requirement for service providers only

8.3.10.1   Additional requirement for service providers only

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 56

--- page 66 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                        (Check one response for each requirement)
                                                                                   In       In Place    In Place with    Not        Not      Not in
                                                                                  Place    with CCW    Remediation   Applicable  Tested    Place

8.3.11   Where authentication factors such as physical or logical    •  Examine authentication          □        □           □            □         □        □
         security tokens, smart cards, or certificates are used:        policies and procedures.
         •  Factors are assigned to an individual user and not       •  Interview security personnel.
            shared among multiple users.                             •  Examine system
         •  Physical and/or logical controls ensure only the           configuration settings and/or
            intended user can use that factor to gain access.          observe physical controls,
                                                                       as applicable.

8.4 Multi-factor authentication (MFA) is implemented to secure access into the CDE.

8.4.1    MFA is implemented for all non-console access into the      •  Examine network and/or          □        □           □            □         □        □
         CDE for personnel with administrative access.                  system configurations.
                                                                     •  Observe administrator
                                                                        personnel logging into the
                                                                        CDE.

         Applicability Notes

         The requirement for MFA for non-console administrative access applies to all personnel
         with elevated or increased privileges accessing the CDE via a non-console connection—
         that is, via logical access occurring over a network interface rather than via a direct,
         physical connection.
         MFA is considered a best practice for non-console administrative access to in-scope
         system components that are not part of the CDE.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                              Page 57

--- page 67 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

8.4.2   MFA is implemented for all access into the CDE.   •  Examine network and/or      □       □           □               □           □        □
                                                             system configurations.
                                                          •  Observe personnel logging
                                                             in to the CDE.
                                                          •  Examine evidence.

        Applicability Notes

        This requirement does not apply to:

        •  Application or system accounts performing automated functions.
        •  User accounts on point-of-sale terminals that have access to only one card number at a
           time to facilitate a single transaction (such as IDs used by cashiers on point-of-sale
           terminals).

        MFA is required for both types of access specified in Requirements 8.4.2 and 8.4.3.
        Therefore, applying MFA to one type of access does not replace the need to apply another
        instance of MFA to the other type of access. If an individual first connects to the entity's
        network via remote access, and then later initiates a connection into the CDE from within
        the network, per this requirement the individual would authenticate using MFA twice, once
        when connecting via remote access to the entity's network and once when connecting via
        non-console administrative access from the entity's network into the CDE.

        The MFA requirements apply for all types of system components, including cloud, hosted
        systems, and on-premises applications, network security devices, workstations, servers,
        and endpoints, and includes access directly to an entity's networks or systems as well as
        web-based access to an application or function.

        MFA for remote access into the CDE can be implemented at the network or
        system/application level; it does not have to be applied at both levels. For example, if MFA
        is used when a user connects to the CDE network, it does not have to be used when the
        user logs into each system or application within the CDE.

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 58

--- page 68 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In       In Place     In Place with   Not          Not       Not in
                                              Place    with CCW     Remediation     Applicable   Tested    Place

8.4.3   MFA is implemented for all remote network access       •   Examine network and/or        □        □            □               □            □         □
        originating from outside the entity's network that         system configurations for
        could access or impact the CDE as follows:                 remote access servers and
        •   All remote access by all personnel, both users and     systems.
            administrators, originating from outside the entity's  •   Observe personnel (for
            network.                                               example, users and
        •   All remote access by third parties and vendors.        administrators) connecting
                                                                   remotely to the network.

        Applicability Notes

        The requirement for MFA for remote access originating from outside the entity's network
        applies to all user accounts that can access the network remotely, where that remote
        access leads to or could lead to access into the CDE.

        If remote access is to a part of the entity's network that is properly segmented from the
        CDE, such that remote users cannot access or impact the CDE, MFA for remote access to
        that part of the network is not required. However, MFA is required for any remote access to
        networks with access to the CDE and is recommended for all remote access to the entity's
        networks.

        The MFA requirements apply for all types of system components, including cloud, hosted
        systems, and on-premises applications, network security devices, workstations, servers,
        and endpoints, and includes access directly to an entity's networks or systems as well as
        web-based access to an application or function.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 59

--- page 69 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

8.5 Multi-factor authentication (MFA) systems are configured to prevent misuse.

8.5.1   MFA systems are implemented as follows:          • Examine vendor system          □       □           □               □           □        □
        • The MFA system is not susceptible to replay      documentation.
          attacks.                                       • Examine system
        • MFA systems cannot be bypassed by any users,    configurations for the MFA
          including administrative users unless specially  implementation.
          documented, and authorized by management on an • Interview responsible
          exception basis, for a limited time period.      personnel and observe
        • At least two different types of authentication   processes.
          factors are used.                              • Observe personnel logging
        • Success of all authentication factors is         into system components in
          required before access is granted.               the CDE.
                                                        • Observe personnel
                                                          connecting remotely from
                                                          outside the entity's network.

        Applicability Notes

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 60

--- page 70 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

8.6 Use of application and system accounts and associated authentication factors is strictly managed.

8.6.1   If accounts used by systems or applications can be used      •   Examine application and          □        □           □            □          □        □
        for interactive login, they are managed as follows:              system accounts that can be
        •   Interactive use is prevented unless needed for an            used interactively.
            exceptional circumstance.                                •   Interview administrative
        •   Interactive use is limited to the time needed for the        personnel.
            exceptional circumstance.
        •   Business justification for interactive use is
            documented.
        •   Interactive use is explicitly approved by
            management.
        •   Individual user identity is confirmed before access to
            account is granted.
        •   Every action taken is attributable to an individual
            user.

        Applicability Notes

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 61

--- page 71 ---

PCI DSS Requirement                                          Expected Testing                                    Response*
                                                                                                              (Check one response for each requirement)
                                                                                                    In        In Place      In Place with      Not          Not        Not in
                                                                                                   Place      with CCW      Remediation     Applicable    Tested      Place

8.6.2   Passwords/passphrases for any application and system        •   Interview personnel.        □            □               □              □            □          □
        accounts that can be used for interactive login are not      •   Examine system
        hard coded in scripts, configuration/property files, or          development procedures.
        bespoke and custom source code.                              •   Examine scripts,
                                                                         configuration/property files,
                                                                         and bespoke and custom
                                                                         source code for application
                                                                         and system accounts that
                                                                         can be used for interactive
                                                                         login.

        Applicability Notes

        Stored passwords/passphrases are required to be encrypted in accordance with PCI DSS
        Requirement 8.3.2.

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

8.6.3   Passwords/passphrases for any application and system        •   Examine policies and        □            □               □              □            □          □
        accounts are protected against misuse as follows:               procedures.
        •   Passwords/passphrases are changed periodically (at      •   Examine the targeted risk
            the frequency defined in the entity's targeted risk          analysis.
            analysis, which is performed according to all           •   Interview responsible
            elements specified in Requirement 12.3.1) and upon          personnel.
            suspicion or confirmation of compromise.                •   Examine system
        •   Passwords/passphrases are constructed with                  configuration settings.
            sufficient complexity appropriate for how frequently
            the entity changes the passwords/passphrases.

        Applicability Notes

        This requirement is a best practice until 31 March 2025, after which it will be required and
        must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                          Page 62

--- page 72 ---

Requirement 9: Restrict Physical Access to Cardholder Data

                                                                                          Response♦
                                                                                          (Check one response for each requirement)
         PCI DSS Requirement                          Expected Testing             In      In Place    In Place with    Not      Not     Not in
                                                                                  Place   with CCW    Remediation   Applicable  Tested   Place

9.1 Processes and mechanisms for restricting physical access to cardholder data are defined and understood.

9.1.1    All security policies and operational procedures that are   •  Examine documentation.      □       □           □           □        □       □
         identified in Requirement 9 are:                           •  Interview personnel.
         •  Documented.
         •  Kept up to date.
         •  In use.
         •  Known to all affected parties.

9.1.2    Roles and responsibilities for performing activities in     •  Examine documentation.      □       □           □           □        □       □
         Requirement 9 are documented, assigned, and                •  Interview responsible
         understood.                                                   personnel.

9.2 Physical access controls manage entry into facilities and systems containing cardholder data.

9.2.1    Appropriate facility entry controls are in place to restrict   •  Observe physical entry    □       □           □           □        □       □
         physical access to systems in the CDE.                           controls.
                                                                    •  Interview responsible
                                                                       personnel.

9.2.1.1  Individual physical access to sensitive areas within the   •  Observe locations where      □       □           □           □        □       □
         CDE is monitored with either video cameras or physical         individual physical access to
         access control mechanisms (or both) as follows:               sensitive areas within the
         •  Entry and exit points to/from sensitive areas within        CDE occurs.
            the CDE are monitored.                                  •  Observe the physical access
         •  Monitoring devices or mechanisms are protected              control mechanisms and/or
            from tampering or disabling.                               examine video cameras.
         •  Collected data is reviewed and correlated with other    •  Interview responsible
            entries.                                                   personnel.
         •  Collected data is stored for at least three months,
            unless otherwise restricted by law.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                   Page 63

--- page 73 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

9.2.2   Physical and/or logical controls are implemented to     • Interview responsible          □   □   □   □   □   □
        restrict use of publicly accessible network jacks within   personnel.
        the facility.                                           • Observe locations of publicly
                                                                  accessible network jacks.

9.2.3   Physical access to wireless access points, gateways,   • Interview responsible          □   □   □   □   □   □
        networking/communications hardware, and                   personnel.
        telecommunication lines within the facility is          • Observe locations of
        restricted.                                               hardware and lines.

9.2.4   Access to consoles in sensitive areas is restricted via • Observe a system               □   □   □   □   □   □
        locking when not in use.                                  administrator's attempt to log
                                                                  into consoles in sensitive
                                                                  areas.

9.3 Physical access for personnel and visitors is authorized and managed.

9.3.1   Procedures are implemented for authorizing and          • Examine documented             □   □   □   □   □   □
        managing physical access of personnel to the CDE,         procedures.
        including:                                              • Observe identification
        • Identifying personnel.                                  methods, such as ID badges.
        • Managing changes to an individual's physical access   • Observe processes.
          requirements.
        • Revoking or terminating personnel identification.
        • Limiting access to the identification process or
          system to authorized personnel.

9.3.1.1 Physical access to sensitive areas within the CDE for  • Observe personnel in           □   □   □   □   □   □
        personnel is controlled as follows:                       sensitive areas within the
        •  Access is authorized and based on individual job       CDE.
           function.                                           • Interview responsible
        •  Access is revoked immediately upon termination.        personnel.
        •  All physical access mechanisms, such as keys,       • Examine physical access
           access cards, etc., are returned or disabled upon      control lists.
           termination.                                        • Observe processes.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                              Page 64

--- page 74 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

9.3.2   Procedures are implemented for authorizing and       •  Examine documented          □       □       □       □       □       □
        managing visitor access to the CDE, including:          procedures.
        •  Visitors are authorized before entering.          •  Observe processes when
        •  Visitors are escorted at all times.                  visitors are present in the
        •  Visitors are clearly identified and given a badge or CDE.
           other identification that expires.                •  Interview personnel.
        •  Visitor badges or other identification visibly    •  Observe the use of visitor
           distinguishes visitors from personnel.               badges or other identification.

9.3.3   Visitor badges or identification are surrendered or  •  Observe visitors leaving the  □       □       □       □       □       □
        deactivated before visitors leave the facility or at    facility
        the date of expiration.                              •  Interview personnel.

9.3.4   A visitor log is used to maintain a physical record  •  Examine the visitor log.      □       □       □       □       □       □
        of visitor activity within the facility and within   •  Interview responsible
        sensitive areas, including:                             personnel.
        •  The visitor's name and the organization           •  Examine visitor log storage
           represented.                                         locations.
        •  The date and time of the visit.
        •  The name of the personnel authorizing physical
           access.
        •  Retaining the log for at least three months, unless
           otherwise restricted by law.

9.4  Media with cardholder data is securely stored, accessed, distributed, and destroyed.

9.4.1   All media with cardholder data is physically secured.  •  Examine documentation.      □       □       □       □       □       □

9.4.1.1 Offline media backups with cardholder data are stored  •  Examine documented          □       □       □       □       □       □
        in a secure location.                                   procedures.
                                                             •  Examine logs or other
                                                                documentation.
                                                             •  Interview responsible
                                                                personnel at the storge
                                                                location(s).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                   Page 65

--- page 75 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

9.4.1.2   The security of the offline media backup location(s)    •  Examine documented          □       □            □               □            □         □
          with cardholder data is reviewed at least once every 12    procedures, logs, or other
          months.                                                     documentation.
                                                                  •  Interview responsible
                                                                     personnel at the storage
                                                                     location(s).

9.4.2     All media with cardholder data is classified in         •  Examine documented          □       □            □               □            □         □
          accordance with the sensitivity of the data.               procedures.
                                                                  •  Examine media logs or other
                                                                     documentation.

9.4.3     Media with cardholder data sent outside the facility is •  Examine documented          □       □            □               □            □         □
          secured as follows:                                        procedures.
          •  Media sent outside the facility is logged.           •  Interview personnel.
          •  Media is sent by secured courier or other delivery   •  Examine records.
             method that can be accurately tracked.               •  Examine offsite tracking logs
          •  Offsite tracking logs include details about media       for all media.
             location.

9.4.4     Management approves all media with cardholder data      •  Examine documented          □       □            □               □            □         □
          that is moved outside the facility (including when media   procedures.
          is distributed to individuals).                         •  Examine offsite media
                                                                     tracking logs.
                                                                  •  Interview responsible
                                                                     personnel.

          Applicability Notes

          Individuals approving media movements should have the appropriate level of management
          authority to grant this approval. However, it is not specifically required that such individuals
          have "manager" as part of their title.

9.4.5     Inventory logs of all electronic media with cardholder  •  Examine documented          □       □            □               □            □         □
          data are maintained.                                       procedures.
                                                                  •  Examine electronic media
                                                                     inventory logs.
                                                                  •  Interview responsible
                                                                     personnel.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                         April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 66

--- page 76 ---

PCI DSS Requirement                                          Expected Testing                          Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In       In Place    In Place with    Not         Not       Not in
                                                                                             Place    with CCW    Remediation   Applicable   Tested     Place

9.4.5.1   Inventories of electronic media with cardholder data are    •   Examine documented           □          □              □            □          □         □
          conducted at least once every 12 months.                        procedures.
                                                                       •   Examine electronic media
                                                                           inventory logs.
                                                                       •   Interview responsible
                                                                           personnel.

9.4.6     Hard-copy materials with cardholder data are                 •   Examine the periodic media   □          □              □            □          □         □
          destroyed when no longer needed for business or legal            destruction policy.
          reasons, as follows:                                         •   Observe processes.
          •   Materials are cross-cut shredded, incinerated, or        •   Interview personnel.
              pulped so that cardholder data cannot be                 •   Observe storage containers.
              reconstructed.
          •   Materials are stored in secure storage containers
              prior to destruction.

          Applicability Notes

          These requirements for media destruction when that media is no longer needed for
          business or legal reasons are separate and distinct from PCI DSS Requirement 3.2.1, which
          is for securely deleting cardholder data when no longer needed per the entity's cardholder
          data retention policies.

9.4.7     Electronic media with cardholder data is destroyed           •   Examine the periodic media   □          □              □            □          □         □
          when no longer needed for business or legal reasons              destruction policy.
          via one of the following:                                    •   Observe the media
          •   The electronic media is destroyed.                           destruction process.
          •   The cardholder data is rendered unrecoverable so         •   Interview responsible
              that it cannot be reconstructed.                             personnel.

          Applicability Notes

          These requirements for media destruction when that media is no longer needed for
          business or legal reasons are separate and distinct from PCI DSS Requirement 3.2.1, which
          is for securely deleting cardholder data when no longer needed per the entity's cardholder
          data retention policies.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 67

--- page 77 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

9.5 Point-of-interaction (POI) devices are protected from tampering and unauthorized substitution.

9.5.1    POI devices that capture payment card data via          •  Examine documented policies      □        □           □             □          □        □
         direct physical interaction with the payment card form     and procedures.
         factor are protected from tampering and
         unauthorized substitution, including the following:
         •  Maintaining a list of POI devices.
         •  Periodically inspecting POI devices to look for
            tampering or unauthorized substitution.
         •  Training personnel to be aware of suspicious
            behavior and to report tampering or unauthorized
            substitution of devices.

         Applicability Notes

         These requirements apply to deployed POI devices used in card-present transactions
         (that is, a payment card form factor such as a card that is swiped, tapped, or dipped). This
         requirement is not intended to apply to manual PAN key-entry components such as
         computer keyboards.
         This requirement is recommended, but not required, for manual PAN key-entry
         components such as computer keyboards.
         This requirement does not apply to commercial off-the-shelf (COTS) devices (for
         example, smartphones or tablets), which are mobile merchant-owned devices designed
         for mass-market distribution.

9.5.1.1  An up-to-date list of POI devices is maintained,       •  Examine the list of POI           □        □           □             □          □        □
         including:                                                devices.
         •  Make and model of the device.                       •  Observe POI devices and
         •  Location of device.                                    device locations.
         •  Device serial number or other methods of unique     •  Interview personnel.
            identification.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 68

--- page 78 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

9.5.1.2   POI device surfaces are periodically inspected to     •  Examine documented          □       □           □               □           □        □
          detect tampering and unauthorized substitution.          procedures.
                                                                •  Interview responsible
                                                                   personnel.
                                                                •  Observe inspection
                                                                   processes.

9.5.1.2.1 The frequency of periodic POI device inspections     •  Examine the targeted risk    □       □           □               □           □        □
          and the type of inspections performed is defined in      analysis.
          the entity's targeted risk analysis, which is performed  •  Examine documented results
          according to all elements specified in Requirement        of periodic device inspections.
          12.3.1.                                               •  Interview personnel.

          Applicability Notes

          This requirement is a best practice until 31 March 2025, after which it will be required and
          must be fully considered during a PCI DSS assessment.

9.5.1.3   Training is provided for personnel in POI             •  Review training materials for □       □           □               □           □        □
          environments to be aware of attempted tampering or       personnel in POI
          replacement of POI devices, and includes:                environments.
          •  Verifying the identity of any third-party persons  •  Interview responsible
             claiming to be repair or maintenance personnel,       personnel.
             before granting them access to modify or
             troubleshoot devices.
          •  Procedures to ensure devices are not installed,
             replaced, or returned without verification.
          •  Being aware of suspicious behavior around
             devices.
          •  Reporting suspicious behavior and indications of
             device tampering or substitution to appropriate
             personnel.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                              Page 69

--- page 79 ---

Regularly Monitor and Test Networks

Requirement 10: Log and Monitor All Access to System Components and Cardholder Data

                                                                                          Response*
                                                                               (Check one response for each requirement)
         PCI DSS Requirement                          Expected Testing        In      In Place    In Place with    Not       Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested   Place

10.1 Processes and mechanisms for logging and monitoring all access to system components and cardholder data are defined and documented.

10.1.1   All security policies and operational procedures that    • Examine documentation.          □       □           □           □        □       □
         are identified in Requirement 10 are:                    • Interview personnel.
         • Documented.
         • Kept up to date.
         • In use.
         • Known to all affected parties.

10.1.2   Roles and responsibilities for performing activities in  • Examine documentation.          □       □           □           □        □       □
         Requirement 10 are documented, assigned, and             • Interview responsible
         understood.                                                personnel.

10.2 Audit logs are implemented to support the detection of anomalies and suspicious activity, and the forensic analysis of events.

10.2.1   Audit logs are enabled and active for all system         • Interview the system            □       □           □           □        □       □
         components and cardholder data.                            administrator.
                                                                  • Examine system configurations.

10.2.1.1 Audit logs capture all individual user access to         • Examine audit log               □       □           □           □        □       □
         cardholder data.                                           configurations.
                                                                  • Examine audit log data.

10.2.1.2 Audit logs capture all actions taken by any individual   • Examine audit log               □       □           □           □        □       □
         with administrative access, including any interactive      configurations.
         use of application or system accounts.                   • Examine audit log data.

10.2.1.3 Audit logs capture all access to audit logs.             • Examine audit log               □       □           □           □        □       □
                                                                    configurations.
                                                                  • Examine audit log data.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                  Page 70

--- page 80 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not        Not in
                                                    Place   with CCW     Remediation      Applicable   Tested     Place

10.2.1.4   Audit logs capture all invalid logical access       •  Examine audit log          □       □            □                □            □          □
           attempts.                                              configurations.
                                                               •  Examine audit log data.

10.2.1.5   Audit logs capture all changes to identification and   •  Examine audit log       □       □            □                □            □          □
           authentication credentials including, but not limited     configurations.
           to:                                                    •  Examine audit log data.
           •  Creation of new accounts.
           •  Elevation of privileges.
           •  All changes, additions, or deletions to accounts
              with administrative access.

10.2.1.6   Audit logs capture the following:                   •  Examine audit log          □       □            □                □            □          □
           •  All initialization of new audit logs, and           configurations.
           •  All starting, stopping, or pausing of the existing  •  Examine audit log data.
              audit logs.

10.2.1.7   Audit logs capture all creation and deletion of     •  Examine audit log          □       □            □                □            □          □
           system-level objects.                                   configurations.
                                                               •  Examine audit log data.

10.2.2     Audit logs record the following details for each    •  Interview responsible       □       □            □                □            □          □
           auditable event:                                       personnel.
           •  User identification.                             •  Examine audit log
           •  Type of event.                                      configurations.
           •  Date and time.                                   •  Examine audit log data.
           •  Success and failure indication.
           •  Origination of event.
           •  Identity or name of affected data, system
              component, resource, or service (for example,
              name and protocol).

10.3 Audit logs are protected from destruction and unauthorized modifications.

10.3.1     Read access to audit logs files is limited to those  •  Interview system administrators  □   □          □                □            □          □
           with a job-related need.                             •  Examine system configurations
                                                                  and privileges.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 71

--- page 81 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

10.3.2   Audit log files are protected to prevent modifications   • Examine system configurations    □   □   □   □   □   □
         by individuals.                                            and privileges.
                                                                  • Interview system
                                                                    administrators.

10.3.3   Audit log files, including those for external-facing     • Examine backup configurations    □   □   □   □   □   □
         technologies, are promptly backed up to a secure,          or log files.
         central, internal log server(s) or other media that is
         difficult to modify.

10.3.4   File integrity monitoring or change-detection            • Examine system settings.         □   □   □   □   □   □
         mechanisms is used on audit logs to ensure that          • Examine monitored files.
         existing log data cannot be changed without              • Examine results from
         generating alerts.                                         monitoring activities.

10.4  Audit logs are reviewed to identify anomalies or suspicious activity.

10.4.1   The following audit logs are reviewed at least once      • Examine security policies and    □   □   □   □   □   □
         daily:                                                     procedures.
         • All security events.                                   • Observe processes.
         • Logs of all system components that store,              • Interview personnel.
           process, or transmit CHD and/or SAD.
         • Logs of all critical system components.
         • Logs of all servers and system components that
           perform security functions (for example, network
           security controls, intrusion-detection
           systems/intrusion-prevention systems (IDS/IPS),
           authentication servers).

10.4.1.1  Automated mechanisms are used to perform audit          • Examine log review               □   □   □   □   □   □
          log reviews.                                              mechanisms.
                                                                  • Interview personnel.
          Applicability Notes

          This requirement is a best practice until 31 March 2025, after which it will be required and
          must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                              Page 72

--- page 82 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

10.4.2   Logs of all other system components (those not    •  Examine security policies and    □    □    □    □    □    □
         specified in Requirement 10.4.1) are reviewed        procedures.
         periodically.                                     •  Examine documented results of
                                                              log reviews.
                                                           •  Interview personnel.

         Applicability Notes

         This requirement is applicable to all other in-scope system components not included in
         Requirement 10.4.1.

10.4.2.1 The frequency of periodic log reviews for all other   •  Examine the targeted risk       □    □    □    □    □    □
         system components (not defined in Requirement            analysis.
         10.4.1) is defined in the entity's targeted risk      •  Examine documented results of
         analysis, which is performed according to all            periodic log reviews.
         elements specified in Requirement 12.3.1.             •  Interview personnel.

         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required and
         must be fully considered during a PCI DSS assessment.

10.4.3   Exceptions and anomalies identified during the    •  Examine security policies and    □    □    □    □    □    □
         review process are addressed.                        procedures.
                                                           •  Observe processes.
                                                           •  Interview personnel.

10.5 Audit log history is retained and available for analysis.

10.5.1   Retain audit log history for at least 12 months, with   •  Examine documented audit log    □    □    □    □    □    □
         at least the most recent three months immediately         retention policies and
         available for analysis.                                   procedures.
                                                                •  Examine configurations of audit
                                                                   log history.
                                                                •  Examine audit logs.
                                                                •  Interview personnel.
                                                                •  Observe processes.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                  Page 73

--- page 83 ---

PCI DSS Requirement   Expected Testing   Response*
(Check one response for each requirement)
In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

10.6 Time-synchronization mechanisms support consistent time settings across all systems.

10.6.1   System clocks and time are synchronized using time-synchronization technology.

         Applicability Notes

         Keeping time-synchronization technology current includes managing vulnerabilities and patching the technology according to PCI DSS Requirements 6.3.1 and 6.3.3.   • Examine system configuration settings.   □   □   □   □   □   □

10.6.2   Systems are configured to the correct and consistent time as follows:
         • One or more designated time servers are in use.
         • Only the designated central time server(s) receives time from external sources.
         • Time received from external sources is based on International Atomic Time or Coordinated Universal Time (UTC).
         • The designated time server(s) accept time updates only from specific industry-accepted external sources.
         • Where there is more than one designated time server, the time servers peer with one another to keep accurate time.
         • Internal systems receive time information only from designated central time server(s).   • Examine system configuration settings for acquiring, distributing, and storing the correct time.   □   □   □   □   □   □

10.6.3   Time synchronization settings and data are protected as follows:
         • Access to time data is restricted to only personnel with a business need.
         • Any changes to time settings on critical systems are logged, monitored, and reviewed.   • Examine system configurations and time-synchronization settings and logs.
         • Observe processes.   □   □   □   □   □   □

10.7 Failures of critical security control systems are detected, reported, and responded to promptly.

10.7.1   Additional requirement for service providers only

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 74

--- page 84 ---

PCI DSS Requirement                                Expected Testing                                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                          In        In Place      In Place with    Not          Not        Not in
                                                                                          Place     with CCW      Remediation      Applicable   Tested     Place

10.7.2   Failures of critical security control systems are        •  Examine documented             □         □             □                □            □          □
         detected, alerted, and addressed promptly,                  processes.
         including but not limited to failure of the following    •  Observe detection and alerting
         critical security control systems:                          processes.
         •  Network security controls.                            •  Interview personnel.
         •  IDS/IPS.
         •  Change-detection mechanisms.
         •  Anti-malware solutions.
         •  Physical access controls.
         •  Logical access controls.
         •  Audit logging mechanisms.
         •  Segmentation controls (if used).
         •  Audit log review mechanisms.
         •  Automated security testing tools (if used).

         Applicability Notes

         This requirement applies to all entities, including service providers, and will supersede
         Requirement 10.7.1 as of 31 March 2025. It includes two additional critical security control
         systems not in Requirement 10.7.1.

         This requirement is a best practice until 31 March 2025, after which it will be required and
         must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 75

--- page 85 ---

PCI DSS Requirement                                          Expected Testing                                    Response*
                                                                                                              (Check one response for each requirement)
                                                                                                    In       In Place      In Place with      Not          Not        Not in
                                                                                                   Place     with CCW      Remediation     Applicable    Tested      Place

10.7.3   Failures of any critical security controls systems are      •  Examine documented          □          □               □               □            □          □
         responded to promptly, including but not limited to:           processes .
         •  Restoring security functions.                            •  Interview personnel.
         •  Identifying and documenting the duration (date           •  Examine records related to
            and time from start to end) of the security failure.        critical security control systems
         •  Identifying and documenting the cause(s) of                 failures.
            failure and documenting required remediation.
         •  Identifying and addressing any security issues
            that arose during the failure.
         •  Determining whether further actions are required
            as a result of the security failure.
         •  Implementing controls to prevent the cause of
            failure from reoccurring.
         •  Resuming monitoring of security controls.

         Applicability Notes

         This requirement applies only when the entity being assessed is a service provider until 31
         March 2025, after which this requirement will apply to all entities.
         This is a current v3.2.1 requirement that applies to service providers only. However, this
         requirement is a best practice for all other entities until 31 March 2025, after which it will be
         required and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                         Page 76

--- page 86 ---

Requirement 11: Test Security of Systems and Networks Regularly

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                 (Check one response for each requirement)
                                                                                        In       In Place      In Place with    Not          Not       Not in
                                                                                        Place    with CCW      Remediation      Applicable   Tested    Place

11.1 Processes and mechanisms for regularly testing security of systems and networks are defined and understood.

11.1.1   All security policies and operational procedures that    •  Examine documentation.      □        □             □               □            □         □
         are identified in Requirement 11 are:                    •  Interview personnel.
         •  Documented.
         •  Kept up to date.
         •  In use.
         •  Known to all affected parties.

11.1.2   Roles and responsibilities for performing activities in  •  Examine documentation.      □        □             □               □            □         □
         Requirement 11 are documented, assigned, and             •  Interview responsible
         understood.                                                 personnel.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                           April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                Page 77

--- page 87 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In      In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

11.2 Wireless access points are identified and monitored, and unauthorized wireless access points are addressed.

11.2.1   Authorized and unauthorized wireless access points    •  Examine policies and              □       □           □            □         □        □
         are managed as follows:                                  procedures.
         •  The presence of wireless (Wi-Fi) access points     •  Examine the methodology(ies)
            is tested for.                                        in use and the resulting
         •  All authorized and unauthorized wireless access       documentation.
            points are detected and identified.                •  Interview personnel.
         •  Testing, detection, and identification occurs at   •  Examine wireless assessment
            least once every three months.                        results.
         •  If automated monitoring is used, personnel are     •  Examine configuration
            notified via generated alerts.                        settings.

         Applicability Notes

         The requirement applies even when a policy exists that prohibits the use of wireless
         technology since attackers do not read and follow company policy.
         Methods used to meet this requirement must be sufficient to detect and identify both
         authorized and unauthorized devices, including unauthorized devices attached to devices
         that themselves are authorized.

11.2.2   An inventory of authorized wireless access points is  •  Examine documentation.           □       □           □            □         □        □
         maintained, including a documented business
         justification.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 78

--- page 88 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

11.3 External and internal vulnerabilities are regularly identified, prioritized, and addressed.

11.3.1   Internal vulnerability scans are performed as        •  Examine internal scan report    □    □    □    □    □    □
         follows:                                                results.
         •  At least once every three months.                 •  Examine scan tool
         •  High-risk and critical vulnerabilities (per the      configurations.
            entity's vulnerability risk rankings defined at   •  Interview responsible
            Requirement 6.3.1) are resolved.                     personnel.
         •  Rescans are performed that confirm all high-risk
            and critical vulnerabilities (as noted above) have
            been resolved.
         •  Scan tool is kept up to date with latest
            vulnerability information.
         •  Scans are performed by qualified personnel and
            organizational independence of the tester exists.

         Applicability Notes

         It is not required to use a QSA or ASV to conduct internal vulnerability scans.
         Internal vulnerability scans can be performed by qualified, internal staff that are
         reasonably independent of the system component(s) being scanned (for example, a
         network administrator should not be responsible for scanning the network), or an entity
         may choose to have internal vulnerability scans performed by a firm specializing in
         vulnerability scanning.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                   Page 79

--- page 89 ---

PCI DSS Requirement   Expected Testing   Response*
                                          (Check one response for each requirement)
                                          In      In Place    In Place with   Not         Not      Not in
                                          Place   with CCW    Remediation     Applicable  Tested   Place

11.3.1.1   All other applicable vulnerabilities (those not ranked    •  Examine the targeted risk      □       □           □               □           □        □
           as high-risk or critical (per the entity's vulnerability     analysis.
           risk rankings defined at Requirement 6.3.1) are           •  Interview responsible
           managed as follows:                                           personnel.
           •  Addressed based on the risk defined in the             •  Examine internal scan report
              entity's targeted risk analysis, which is                 results or other documentation.
              performed according to all elements specified in
              Requirement 12.3.1.
           •  Rescans are conducted as needed.

           Applicability Notes

           The timeframe for addressing lower-risk vulnerabilities is subject to the results of a risk
           analysis per Requirement 12.3.1 that includes (minimally) identification of assets being
           protected, threats, and likelihood and/or impact of a threat being realized.

           This requirement is a best practice until 31 March 2025, after which it will be required and
           must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                                April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                     Page 80

--- page 90 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place     In Place with    Not          Not       Not in
                                                    Place   with CCW     Remediation      Applicable   Tested    Place

11.3.1.2   Internal vulnerability scans are performed via
           authenticated scanning as follows:

           •  Systems that are unable to accept credentials for   •  Examine documentation.              □   □   □   □   □   □
              authenticated scanning are documented.              •  Examine scan tool
           •  Sufficient privileges are used for those systems       configurations.                      □   □   □   □   □   □
              that accept credentials for scanning.               •  Examine scan report results.
           •  If accounts used for authenticated scanning can     •  Interview personnel.                 □   □   □   □   □   □
              be used for interactive login, they are managed     •  Examine accounts used for
              in accordance with Requirement 8.2.2.                  authenticated scanning.

           Applicability Notes

           The authenticated scanning tools can be either host-based or network-based.
           "Sufficient" privileges are those needed to access system resources such that a thorough
           scan can be conducted that detects known vulnerabilities.
           This requirement does not apply to system components that cannot accept credentials for
           scanning. Examples of systems that may not accept credentials for scanning include
           some network and security appliances, mainframes, and containers.
           This requirement is a best practice until 31 March 2025, after which it will be required and
           must be fully considered during a PCI DSS assessment.

11.3.1.3   Internal vulnerability scans are performed after any   •  Examine change control              □   □   □   □   □   □
           significant change as follows:                            documentation.
           •  High-risk and critical vulnerabilities (per the     •  Interview personnel.
              entity's vulnerability risk rankings defined at     •  Examine internal scan and
              Requirement 6.3.1) are resolved.                       rescan report as applicable.
           •  Rescans are conducted as needed.                    •  Interview personnel.
           •  Scans are performed by qualified personnel and
              organizational independence of the tester exists
              (not required to be a QSA or ASV).

           Applicability Notes

           Authenticated internal vulnerability scanning per Requirement 11.3.1.2 is not required for
           scans performed after significant changes.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                   Page 81

--- page 91 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In      In Place    In Place with    Not        Not      Not in
                                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

11.3.2   External vulnerability scans are performed as          • Examine ASV scan reports.   □        □             □             □          □         □
         follows:                                               •
         • At least once every three months.
         • By a PCI SSC Approved Scanning Vendor (ASV)
         • Vulnerabilities are resolved and ASV Program
           Guide requirements for a passing scan are met.
         • Rescans are performed as needed to confirm
           that vulnerabilities are resolved per the ASV
           Program Guide requirements for a passing scan.

         Applicability Notes

         For initial PCI DSS compliance, it is not required that four passing scans be completed
         within 12 months if the assessor verifies: 1) the most recent scan result was a passing
         scan, 2) the entity has documented policies and procedures requiring scanning at least
         once every three months, and 3) vulnerabilities noted in the scan results have been
         corrected as shown in a re-scan(s).

         However, for subsequent years after the initial PCI DSS assessment, passing scans at
         least every three months must have occurred.

         ASV scanning tools can scan a vast array of network types and topologies. Any specifics
         about the target environment (for example, load balancers, third-party providers, ISPs,
         specific configurations, protocols in use, scan interference) should be worked out
         between the ASV and scan customer.

         Refer to the ASV Program Guide published on the PCI SSC website for scan customer
         responsibilities, scan preparation, etc.

11.3.2.1 External vulnerability scans are performed after any   • Examine change control        □        □             □             □          □         □
         significant change as follows:                           documentation.
         • Vulnerabilities that are scored 4.0 or higher by     • Interview personnel.
           the CVSS are resolved.                               • Examine external scan, and as
         • Rescans are conducted as needed.                       applicable rescan reports.
         • Scans are performed by qualified personnel and
           organizational independence of the tester exists
           (not required to be a QSA or ASV).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 82

--- page 92 ---

PCI DSS Requirement   Expected Testing   Response*
(Check one response for each requirement)
In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

11.4 External and internal penetration testing is regularly performed, and exploitable vulnerabilities and security weaknesses are corrected.

11.4.1   A penetration testing methodology is defined, documented, and implemented by the entity, and includes:
   • Industry-accepted penetration testing approaches.
   • Coverage for the entire CDE perimeter and critical systems.
   • Testing from both inside and outside the network.
   • Testing to validate any segmentation and scope-reduction controls.
   • Application-layer penetration testing to identify, at a minimum, the vulnerabilities listed in Requirement 6.2.4.
   • Network-layer penetration tests that encompass all components that support network functions as well as operating systems.
   • Review and consideration of threats and vulnerabilities experienced in the last 12 months.
   • Documented approach to assessing and addressing the risk posed by exploitable vulnerabilities and security weaknesses found during penetration testing.
   • Retention of penetration testing results and remediation activities results for at least 12 months.   • Examine documentation.
   • Interview personnel.   □   □   □   □   □   □

**Applicability Notes**

Testing from inside the network (or "internal penetration testing") means testing from both inside the CDE and into the CDE from trusted and untrusted internal networks.

Testing from outside the network (or "external penetration testing") means testing the exposed external perimeter of trusted networks, and critical systems connected to or accessible to public network infrastructures.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 83

--- page 93 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                          (Check one response for each requirement)
                                                                                    In       In Place     In Place with    Not        Not      Not in
                                                                                   Place    with CCW      Remediation   Applicable  Tested    Place

11.4.2   Internal penetration testing is performed:              •  Examine scope of work.              □        □            □            □          □        □
         •  Per the entity's defined methodology.                •  Examine results from the most
         •  At least once every 12 months.                          recent external penetration
         •  After any significant infrastructure or application     test.
            upgrade or change.                                   •  Interview responsible
         •  By a qualified internal resource or qualified           personnel.
            external third-party
         •  Organizational independence of the tester exists
            (not required to be a QSA or ASV).

11.4.3   External penetration testing is performed:              •  Examine scope of work.              □        □            □            □          □        □
         •  Per the entity's defined methodology.                •  Examine results from the most
         •  At least once every 12 months.                          recent external penetration
         •  After any significant infrastructure or application     test.
            upgrade or change.                                   •  Interview responsible
         •  By a qualified internal resource or qualified           personnel.
            external third-party.
         •  Organizational independence of the tester exists
            (not required to be a QSA or ASV).

11.4.4   Exploitable vulnerabilities and security weaknesses      •  Examine penetration testing        □        □            □            □          □        □
         found during penetration testing are corrected as           results.
         follows:
         •  In accordance with the entity's assessment of
            the risk posed by the security issue as defined in
            Requirement 6.3.1.
         •  Penetration testing is repeated to verify the
            corrections.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 84

--- page 94 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place     In Place with     Not          Not        Not in
                                              Place   with CCW     Remediation       Applicable   Tested     Place

11.4.5   If segmentation is used to isolate the CDE from    • Examine segmentation         □       □            □                □            □          □
         other networks, penetration tests are performed on   controls.
         segmentation controls as follows:                  • Review penetration-testing
         • At least once every 12 months and after any        methodology.
           changes to segmentation controls/methods         • Examine the results from the
         • Covering all segmentation controls/methods in      most recent penetration test.
           use.                                             • Interview responsible
         • According to the entity's defined penetration      personnel.
           testing methodology.
         • Confirming that the segmentation
           controls/methods are operational and effective,
           and isolate the CDE from all out-of-scope
           systems.
         • Confirming effectiveness of any use of isolation
           to separate systems with differing security levels
           (see Requirement 2.2.3).
         • Performed by a qualified internal resource or
           qualified external third party.
         • Organizational independence of the tester exists
           (not required to be a QSA or ASV).

11.4.6   Additional requirement for service providers
         only.

11.4.7   Additional requirement for multi-tenant service
         providers only.


PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 85

--- page 95 ---

PCI DSS Requirement   Expected Testing   Response*
(Check one response for each requirement)
In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

11.5 Network intrusions and unexpected file changes are detected and responded to.

11.5.1   Intrusion-detection and/or intrusion-prevention techniques are used to detect and/or prevent intrusions into the network as follows:
   • All traffic is monitored at the perimeter of the CDE.
   • All traffic is monitored at critical points in the CDE.
   • Personnel are alerted to suspected compromises.
   • All intrusion-detection and prevention engines, baselines, and signatures are kept up to date.
   • Examine system configurations and network diagrams.
   • Examine system configurations.
   • Interview responsible personnel.
   • Examine vendor documentation.
   □   □   □   □   □   □

11.5.1.1   Additional requirement for service providers only.

11.5.2   A change-detection mechanism (for example, file integrity monitoring tools) is deployed as follows:
   • To alert personnel to unauthorized modification (including changes, additions, and deletions) of critical files.
   • To perform critical file comparisons at least once weekly.
   • Examine system settings for the change-detection mechanism.
   • Examine monitored files.
   • Examine results from monitoring activities.
   □   □   □   □   □   □

   Applicability Notes

   For change-detection purposes, critical files are usually those that do not regularly change, but the modification of which could indicate a system compromise or risk of compromise. Change-detection mechanisms such as file integrity monitoring products usually come pre-configured with critical files for the related operating system. Other critical files, such as those for custom applications, must be evaluated and defined by the entity (that is, the merchant or service provider).

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 86

--- page 96 ---

PCI DSS Requirement   Expected Testing   Response*
(Check one response for each requirement)
In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

11.6 Unauthorized changes on payment pages are detected and responded to.

11.6.1   A change- and tamper-detection mechanism is deployed as follows:

   • To alert personnel to unauthorized modification (including indicators of compromise, changes, additions, and deletions) to the HTTP headers and the contents of payment pages as received by the consumer browser.   • Examine system settings and mechanism configuration settings.
• Examine monitored payment pages.   □   □   □   □   □   □

   • The mechanism is configured to evaluate the received HTTP header and payment page.   • Examine results from monitoring activities.   □   □   □   □   □   □

   • The mechanism is configured to evaluate the received HTTP header and payment page.
   • The mechanism functions are performed as follows:
      –  At least once every seven days
      OR
      –  Periodically (at the frequency defined in the entity's targeted risk analysis, which is performed according to all elements specified in Requirement 12.3.1).   • Examine the mechanism configuration settings.
• Examine configuration settings.
• Interview responsible personnel.
• If applicable, examine the targeted risk analysis.   □   □   □   □   □   □

   Applicability Notes

   The intention of this requirement is not that an entity install software in the systems or browsers of its consumers, but rather that the entity uses techniques such as those described under Examples in the PCI DSS Guidance column to prevent and detect unexpected script activities.

   This requirement is a best practice until 31 March 2025, after which it will be required and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 87

--- page 97 ---

Maintain an Information Security Policy

Requirement 12: Support Information Security with Organizational Policies and Programs

PCI DSS Requirement                                Expected Testing                    Response*
                                                                              (Check one response for each requirement)
                                                                         In       In Place    In Place with    Not        Not      Not in
                                                                        Place    with CCW    Remediation   Applicable   Tested    Place

12.1 A comprehensive information security policy that governs and provides direction for protection of the entity's information assets is known and current.

  12.1.1   An overall information security policy is:                  • Examine the information    □        □            □           □          □        □
           • Established.                                                security policy.
           • Published.                                                • Interview personnel.
           • Maintained.
           • Disseminated to all relevant personnel, as well as
             to relevant vendors and business partners.

  12.1.2   The information security policy is:                         • Examine the information    □        □            □           □          □        □
           • Reviewed at least once every 12 months.                     security policy.
           • Updated as needed to reflect changes to business          • Interview responsible
             objectives or risks to the environment                      personnel.

  12.1.3   The security policy clearly defines information             • Examine the information    □        □            □           □          □        □
           security roles and responsibilities for all personnel,        security policy.
           and all personnel are aware of and acknowledge their        • Interview responsible
           information security responsibilities.                        personnel.
                                                                       • Examine documented
                                                                         evidence.

  12.1.4   Responsibility for information security is formally         • Examine the information    □        □            □           □          □        □
           assigned to a Chief Information Security Officer or           security policy.
           other information security knowledgeable member of
           executive management.

♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 88

--- page 98 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place     In Place with      Not        Not      Not in
                                                                             Place    with CCW      Remediation    Applicable   Tested    Place

12.2 Acceptable use policies for end-user technologies are defined and implemented.

12.2.1   Acceptable use policies for end-user technologies are    •  Examine acceptable use        □         □            □            □         □        □
         documented and implemented, including:                      policies.
         •  Explicit approval by authorized parties.              •  Interview responsible
         •  Acceptable uses of the technology.                       personnel.
         •  List of products approved by the company for
            employee use, including hardware and software.

         Applicability Notes

         Examples of end-user technologies for which acceptable use policies are expected
         include, but are not limited to, remote access and wireless technologies, laptops, tablets,
         mobile phones, and removable electronic media, e-mail usage, and Internet usage.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 89

--- page 99 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place     In Place with     Not        Not      Not in
                                                                             Place    with CCW      Remediation    Applicable   Tested    Place

12.3 Risks to the cardholder data environment are formally identified, evaluated, and managed.

12.3.1   Each PCI DSS requirement that provides flexibility for    •  Examine documented          □        □             □            □         □        □
         how frequently it is performed (for example,                policies and procedures.
         requirements to be performed periodically) is
         supported by a targeted risk analysis that is
         documented and includes:
         •  Identification of the assets being protected.
         •  Identification of the threat(s) that the requirement
            is protecting against.
         •  Identification of factors that contribute to the
            likelihood and/or impact of a threat being realized.
         •  Resulting analysis that determines, and includes
            justification for, how frequently the requirement
            must be performed to minimize the likelihood of
            the threat being realized.
         •  Review of each targeted risk analysis at least
            once every 12 months to determine whether the
            results are still valid or if an updated risk analysis
            is needed
         •  Performance of updated risk analyses when
            needed, as determined by the annual review.
         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required
         and must be fully considered during a PCI DSS assessment.

12.3.2   This requirement is specific to the customized
         approach and does not apply to entities
         completing a self-assessment questionnaire.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                         Page 90

--- page 100 ---

PCI DSS Requirement                                          Expected Testing                    Response*
                                                                                                    (Check one response for each requirement)
                                                                                              In      In Place    In Place with    Not        Not      Not in
                                                                                             Place    with CCW    Remediation   Applicable   Tested    Place

12.3.3   Cryptographic cipher suites and protocols in use are        •  Examine documentation.    □        □           □            □          □        □
         documented and reviewed at least once every 12              •  Interview personnel.
         months, including at least the following:
         •  An up-to-date inventory of all cryptographic cipher
            suites and protocols in use, including purpose and
            where used.
         •  Active monitoring of industry trends regarding
            continued viability of all cryptographic cipher
            suites and protocols in use.
         •  A documented strategy to respond to anticipated
            changes in cryptographic vulnerabilities.

         Applicability Notes

         The requirement applies to all cryptographic suites and protocols used to meet PCI DSS
         requirements.

         This requirement is a best practice until 31 March 2025, after which it will be required
         and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 91

--- page 101 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place    In Place with   Not         Not      Not in
                                              Place   with CCW    Remediation     Applicable  Tested   Place

12.3.4   Hardware and software technologies in use are        • Examine documentation.   □   □   □   □   □   □
         reviewed at least once every 12 months, including at • Interview personnel.
         least the following:
         • Analysis that the technologies continue to receive
           security fixes from vendors promptly.
         • Analysis that the technologies continue to support
           (and do not preclude) the entity's PCI DSS
           compliance.
         • Documentation of any industry announcements or
           trends related to a technology, such as when a
           vendor has announced "end of life" plans for a
           technology.
         • Documentation of a plan, approved by senior
           management, to remediate outdated technologies,
           including those for which vendors have
           announced "end of life" plans.
         Applicability Notes

         This requirement is a best practice until 31 March 2025, after which it will be required
         and must be fully considered during a PCI DSS assessment

12.4 PCI DSS compliance is managed.

12.4.1   Additional requirement for service providers only.

12.4.2   Additional requirement for service providers only.

12.4.2.1 Additional requirement for service providers only.

12.5 PCI DSS scope is documented and validated.

12.5.1   An inventory of system components that are in scope  • Examine the inventory.    □   □   □   □   □   □
         for PCI DSS, including a description of function/use, • Interview personnel.
         is maintained and kept current.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                   Page 92

--- page 102 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In      In Place     In Place with    Not          Not        Not in
                                              Place   with CCW     Remediation      Applicable   Tested     Place

12.5.2   PCI DSS scope is documented and confirmed by the   •  Examine documented          □       □            □                □            □          □
         entity at least once every 12 months and upon         results of scope reviews.
         significant change to the in-scope environment.    •  Interview personnel.

         At a minimum, the scoping validation includes:

         •  Identifying all data flows for the various payment   •  Examine documented      □       □            □                □            □          □
            stages (for example, authorization, capture            results of scope reviews.
            settlement, chargebacks, and refunds) and
            acceptance channels (for example, card-present,
            card-not-present, and e-commerce).

         •  Updating all data-flow diagrams per requirement                                 □       □            □                □            □          □
            1.2.4.

         •  Identifying all locations where account data is                                 □       □            □                □            □          □
            stored, processed, and transmitted, including but
            not limited to: 1) any locations outside of the
            currently defined CDE, 2) applications that
            process CHD, 3) transmissions between systems
            and networks, and 4) file backups.

         •  Identifying all system components in the CDE,                                   □       □            □                □            □          □
            connected to the CDE, or that could impact
            security of the CDE.

         •  Identifying all segmentation controls in use and                                □       □            □                □            □          □
            the environment(s) from which the CDE is
            segmented, including justification for
            environments being out of scope.

         •  Identifying all connections from third-party entities                           □       □            □                □            □          □
            with access to the CDE.

         •  Confirming that all identified data flows, account                              □       □            □                □            □          □
            data, system components, segmentation controls,
            and connections from third parties with access to
            the CDE are included in scope.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                               Page 93

--- page 103 ---

PCI DSS Requirement                                          Expected Testing                                    Response*
                                                                                                          (Check one response for each requirement)
                                                                                                  In       In Place      In Place with      Not        Not      Not in
                                                                                                 Place    with CCW       Remediation    Applicable   Tested    Place

12.5.2    Applicability Notes

(cont.)   This annual confirmation of PCI DSS scope is an activity expected to be performed by
          the entity under assessment, and is not the same, nor is it intended to be replaced by,
          the scoping confirmation performed by the entity's assessor during the annual
          assessment.

12.5.2.1  Additional requirement for service providers only.

12.5.3    Additional requirement for service providers only.

12.6 Security awareness education is an ongoing activity.

12.6.1    A formal security awareness program is implemented      •  Examine the security          □         □             □              □          □         □
          to make all personnel aware of the entity's               awareness program.
          information security policy and procedures, and their
          role in protecting the cardholder data.

12.6.2    The security awareness program is:                      •  Examine security awareness    □         □             □              □          □         □
          •  Reviewed at least once every 12 months, and            program content.
          •  Updated as needed to address any new threats          •  Examine evidence of
             and vulnerabilities that may impact the security of      reviews.
             the entity's CDE, or the information provided to     •  Interview personnel.
             personnel about their role in protecting cardholder
             data.

          Applicability Notes

          This requirement is a best practice until 31 March 2025, after which it will be required
          and must be fully considered during a PCI DSS assessment.

12.6.3    Personnel receive security awareness training as        •  Examine security awareness    □         □             □              □          □         □
          follows:                                                   program records.
          •  Upon hire and at least once every 12 months.         •  Interview applicable
          •  Multiple methods of communication are used.             personnel.
          •  Personnel acknowledge at least once every 12         •  Examine the security
             months that they have read and understood the           awareness program
             information security policy and procedures.            materials.
                                                                  •  Examine personnel
                                                                     acknowledgements.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                              April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                   Page 94

--- page 104 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In Place   In Place with CCW   In Place with Remediation   Not Applicable   Not Tested   Not in Place

12.6.3.1   Security awareness training includes awareness of threats and vulnerabilities that could impact the security of the CDE, including but not limited to:
   • Phishing and related attacks.
   • Social engineering.
   • Examine security awareness training content.   □   □   □   □   □   □

   Applicability Notes

   See Requirement 5.4.1 in PCI DSS for guidance on the difference between technical and automated controls to detect and protect users from phishing attacks, and this requirement for providing users security awareness training about phishing and social engineering. These are two separate and distinct requirements, and one is not met by implementing controls required by the other one.

   This requirement is a best practice until 31 March 2025, after which it will be required and must be fully considered during a PCI DSS assessment.

12.6.3.2   Security awareness training includes awareness about the acceptable use of end-user technologies in accordance with Requirement 12.2.1.
   • Examine security awareness training content.   □   □   □   □   □   □

   Applicability Notes

   This requirement is a best practice until 31 March 2025, after which it will be required and must be fully considered during a PCI DSS assessment.

12.7 Personnel are screened to reduce risks from insider threats.

12.7.1   Potential personnel who will have access to the CDE are screened, within the constraints of local laws, prior to hire to minimize the risk of attacks from internal sources.
   • Interview responsible Human Resource department management personnel.   □   □   □   □   □   □

   Applicability Notes

   For those potential personnel to be hired for positions such as store cashiers, who only have access to one card number at a time when facilitating a transaction, this requirement is a recommendation only.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire   April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.   Page 95

--- page 105 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In      In Place    In Place with    Not       Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested   Place

12.8 Risk to information assets associated with third-party service provider (TPSP) relationships is managed.

12.8.1    A list of all third-party service providers (TPSPs) with    •  Examine policies and          □        □           □           □        □        □
          which account data is shared or that could affect the          procedures.
          security of account data is maintained, including a         •  Examine list of TPSPs.
          description for each of the services provided.

          Applicability Notes

          The use of a PCI DSS compliant TPSP does not make an entity PCI DSS compliant, nor
          does it remove the entity's responsibility for its own PCI DSS compliance.

12.8.2    Written agreements with TPSPs are maintained as             •  Examine policies and          □        □           □           □        □        □
          follows:                                                       procedures.
          •  Written agreements are maintained with all               •  Examine written agreements
             TPSPs with which account data is shared or that             with TPSPs.
             could affect the security of the CDE.
          •  Written agreements include acknowledgments
             from TPSPs that they are responsible for the
             security of account data the TPSPs possess or
             otherwise store, process, or transmit on behalf of
             the entity, or to the extent that they could impact
             the security of the entity's CDE.

          Applicability Notes

          The exact wording of an acknowledgment will depend on the agreement between the
          two parties, the details of the service being provided, and the responsibilities assigned to
          each party. The acknowledgment does not have to include the exact wording provided in
          this requirement.
          Evidence that a TPSP is meeting PCI DSS requirements (for example, a PCI DSS
          Attestation of Compliance (AOC) or a declaration on a company's website) is not the
          same as a written agreement specified in this requirement.

12.8.3    An established process is implemented for engaging          •  Examine policies and          □        □           □           □        □        □
          TPSPs, including proper due diligence prior to                 procedures.
          engagement.                                                 •  Examine evidence.
                                                                      •  Interview responsible
                                                                         personnel.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 96

--- page 106 ---

PCI DSS Requirement   Expected Testing   Response*
                                              (Check one response for each requirement)
                                              In     In Place    In Place with   Not        Not      Not in
                                              Place  with CCW    Remediation     Applicable Tested   Place

12.8.4   A program is implemented to monitor TPSPs' PCI    • Examine policies and        □      □      □      □      □      □
         DSS compliance status at least once every 12        procedures.
         months.                                           • Examine documentation.
                                                           • Interview responsible
                                                             personnel.

         Applicability Notes

         Where an entity has an agreement with a TPSP for meeting PCI DSS requirements on
         behalf of the entity (for example, via a firewall service), the entity must work with the
         TPSP to make sure the applicable PCI DSS requirements are met. If the TPSP does not
         meet those applicable PCI DSS requirements, then those requirements are also "not in
         place" for the entity.

12.8.5   Information is maintained about which PCI DSS     • Examine policies and        □      □      □      □      □      □
         requirements are managed by each TPSP, which are    procedures.
         managed by the entity, and any that are shared    • Examine documentation.
         between the TPSP and the entity.                  • Interview responsible
                                                             personnel.

12.9 Third-party service providers (TPSPs) support their customers' PCI DSS compliance.

12.9.1   Additional requirement for service providers only.

12.9.2   Additional requirement for service providers only.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                    April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                         Page 97

--- page 107 ---

PCI DSS Requirement                                Expected Testing                                Response*
                                                                                              (Check one response for each requirement)
                                                                                         In      In Place    In Place with    Not       Not      Not in
                                                                                        Place    with CCW    Remediation   Applicable  Tested   Place

12.10 Suspected and confirmed security incidents that could impact the CDE are responded to immediately.

12.10.1   An incident response plan exists and is ready to be        •  Examine the incident          □        □             □            □        □        □
          activated in the event of a suspected or confirmed            response plan.
          security incident. The plan includes, but is not limited   •  Interview personnel.
          to:                                                         •  Examine documentation
          •  Roles, responsibilities, and communication and             from previously reported
             contact strategies in the event of a suspected or          incidents.
             confirmed security incident, including notification
             of payment brands and acquirers, at a minimum.
          •  Incident response procedures with specific
             containment and mitigation activities for different
             types of incidents.
          •  Business recovery and continuity procedures.
          •  Data backup processes.
          •  Analysis of legal requirements for reporting
             compromises.
          •  Coverage and responses of all critical system
             components.
          •  Reference or inclusion of incident response
             procedures from the payment brands.

12.10.2   At least once every 12 months, the security incident       •  Interview personnel.          □        □             □            □        □        □
          response plan is:                                          •  Examine documentation.
          •  Reviewed and the content is updated as needed.
          •  Tested, including all elements listed in
             Requirement 12.10.1.

12.10.3   Specific personnel are designated to be available on       •  Interview responsible          □        □             □            □        □        □
          a 24/7 basis to respond to suspected or confirmed             personnel.
          security incidents.                                        •  Examine documentation.

12.10.4   Personnel responsible for responding to suspected          •  Interview incident response    □        □             □            □        □        □
          and confirmed security incidents are appropriately            personnel.
          and periodically trained on their incident response        •  Examine training
          responsibilities.                                             documentation.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                        April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                             Page 98

--- page 108 ---

PCI DSS Requirement   Expected Testing   Response*
                                                    (Check one response for each requirement)
                                                    In      In Place    In Place with   Not         Not      Not in
                                                    Place   with CCW    Remediation     Applicable  Tested   Place

12.10.4.1   The frequency of periodic training for incident       • Examine the targeted risk    □    □    □    □    □    □
            response personnel is defined in the entity's targeted  analysis.
            risk analysis, which is performed according to all
            elements specified in Requirement 12.3.1.

            Applicability Notes

            This requirement is a best practice until 31 March 2025, after which it will be required
            and must be fully considered during a PCI DSS assessment.

12.10.5     The security incident response plan includes           • Examine documentation.       □    □    □    □    □    □
            monitoring and responding to alerts from security      • Observe incident response
            monitoring systems, including but not limited to:        processes.
            •  Intrusion-detection and intrusion-prevention
               systems.
            •  Network security controls.
            •  Change-detection mechanisms for critical files.
            •  The change-and tamper-detection mechanism for
               payment pages. This bullet is a best practice until
               its effective date; refer to Applicability Notes below
               for details.
            •  Detection of unauthorized wireless access points.

            Applicability Notes

            The bullet above (for monitoring and responding to alerts from a change- and tamper-
            detection mechanism for payment pages) is a best practice until 31 March 2025, after
            which it will be required as part of Requirement 12.10.5 and must be fully considered
            during a PCI DSS assessment.

12.10.6     The security incident response plan is modified and    • Examine policies and         □    □    □    □    □    □
            evolved according to lessons learned and to              procedures.
            incorporate industry developments.                     • Examine the security
                                                                     incident response plan.
                                                                   • Interview responsible
                                                                     personnel.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                              Page 99

--- page 109 ---

PCI DSS Requirement                                Expected Testing                    Response*
                                                                                    (Check one response for each requirement)
                                                                              In       In Place    In Place with    Not        Not      Not in
                                                                             Place    with CCW    Remediation   Applicable  Tested    Place

12.10.7   Incident response procedures are in place, to be        •  Examine documented        □        □           □            □         □        □
          initiated upon the detection of stored PAN anywhere        incident response
          it is not expected, and include:                           procedures.
          •  Determining what to do if PAN is discovered          •  Interview personnel.
             outside the CDE, including its retrieval, secure     •  Examine records of
             deletion, and/or migration into the currently           response actions.
             defined CDE, as applicable.
          •  Identifying whether sensitive authentication data is
             stored with PAN.
          •  Determining where the account data came from
             and how it ended up where it was not expected.
          •  Remediating data leaks or process gaps that
             resulted in the account data being where it was
             not expected.

          Applicability Notes

          This requirement is a best practice until 31 March 2025, after which it will be required
          and must be fully considered during a PCI DSS assessment.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                               April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                    Page 100

--- page 110 ---

Appendix A: Additional PCI DSS Requirements

Appendix A1: Additional PCI DSS Requirements for Multi-Tenant Service Providers

This Appendix is not used for merchant assessments.

Appendix A2: Additional PCI DSS Requirements for Entities using SSL/Early TLS for Card-Present POS POI Terminal Connections

                                                                                          Response♦
         PCI DSS Requirement                        Expected Testing           (Check one response for each requirement)
                                                                             In      In Place    In Place with    Not       Not      Not in
                                                                            Place    with CCW    Remediation   Applicable  Tested   Place

A2.1 POI terminals using SSL and/or early TLS are not susceptible to known SSL/TLS exploits.

A2.1.1   Where POS POI terminals at the merchant or payment    • Examine documentation (for    □       □            □          □        □        □
         acceptance location use SSL and/or early TLS, the       example, vendor
         entity confirms the devices are not susceptible to any  documentation,
         known exploits for those protocols.                      system/network
                                                                 configuration details) that
                                                                 verifies the devices are not
                                                                 susceptible to any known
                                                                 exploits for SSL/early TLS.

         Applicability Notes

         This requirement is intended to apply to the entity with the POS POI terminal, such as a
         merchant. This requirement is not intended for service providers who serve as the
         termination or connection point to those POS POI terminals. Requirements A2.1.2 and
         A2.1.3 apply to POS POI service providers.

         The allowance for POS POI terminals that are not currently susceptible to exploits is
         based on currently known risks. If new exploits are introduced to which POS POI
         terminals are susceptible, the POS POI terminals will need to be updated immediately.

A2.1.2   Additional requirement for service providers only.

A2.1.3   Additional requirement for service providers only.


♦ Refer to the "Requirement Responses" section (page v) for information about these response options.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                               Page 101

--- page 111 ---

Appendix A3:    Designated Entities Supplemental Validation (DESV)

This Appendix applies only to entities designated by a payment brand(s) or acquirer as requiring additional validation of existing PCI DSS requirements. Entities required to validate to this Appendix should use the DESV Supplemental Reporting Template and Supplemental Attestation of Compliance for reporting and consult with the applicable payment brand and/or acquirer for submission procedures.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire                                                                                                April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                                                                                                        Page 102

--- page 112 ---

Appendix B: Compensating Controls Worksheet

This Appendix must be completed to define compensating controls for any requirement where In Place with CCW was selected.

**Note:** Only entities that have a legitimate and documented technological or business constraint can consider the use of compensating controls to achieve compliance.

Refer to Appendices B and C in PCI DSS for information about compensating controls and guidance on how to complete this worksheet.

**Requirement Number and Definition:**

                     Information Required                              Explanation

1.  Constraints      Document the legitimate technical or
                     business constraints precluding
                     compliance with the original
                     requirement.

2.  Definition of    Define the compensating controls:
    Compensating     explain how they address the
    Controls         objectives of the original control and
                     the increased risk, if any.

3.  Objective        Define the objective of the original
                     control.

                     Identify the objective met by the
                     compensating control.
                     **Note:** This can be, but is not required
                     to be, the stated Customized Approach
                     Objective listed for this requirement in
                     PCI DSS.

4.  Identified Risk  Identify any additional risk posed by
                     the lack of the original control.

5.  Validation of    Define how the compensating controls
    Compensating     were validated and tested.
    Controls

6.  Maintenance      Define process(es) and controls in
                     place to maintain compensating
                     controls.

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.               Page 103

--- page 113 ---

Appendix C: Explanation of Requirements Noted as In Place with
Remediation

*This Appendix must be completed for each requirement where  In Place with Remediation was selected..*

Requirement          Describe why requirement was          Describe 1) how testing and evidence
                     initially not in place                demonstrates that the control failure was
                                                           addressed and 2) what has been
                                                           implemented to prevent re-occurrence of
                                                           the control failure

*Example:*

*Requirement         The anti-malware solution stopped     Entity identified why the automatic scanning*
*5.3.2               performing automatic scanning.        stopped. Process was implemented to rectify*
                                                           *previous failure and an alert was added to notify*
                                                           *admin of any future failures.*

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.               Page 104

--- page 114 ---

Appendix D: Explanation of Requirements Noted as Not Applicable

*This Appendix must be completed for each requirement where Not Applicable was selected .*

Requirement        Reason Requirement is Not Applicable
Example:
Requirement 3.5.1  Account data is never stored electronically

PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire          April 2022
© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.                Page 105

--- page 115 ---

Appendix E: Explanation of Requirements Noted as Not Tested

*This Appendix must be completed for each requirement where Not Tested was selected.*

Requirement          Description of Requirement(s) Not        Describe why Requirement(s) was Excluded
                     Tested                                   from the Assessment

Examples:

Requirement 10       No requirements from Requirement 10      This assessment only covers requirements in
                     were tested.                             Milestone 1 of the Prioritized Approach.

Requirements         Only Requirement 9 was reviewed for this  Company is a physical hosting provider (CO-
1-8, 10-12           assessment. All other requirements were   LO), and only physical security controls were
                     excluded.                                 considered for this assessment.




*PCI DSS v4.0 SAQ D for Merchants, Section 2: Self-Assessment Questionnaire*                    *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                         *Page 106*

--- page 116 ---

Section 3: Validation and Attestation Details

Part 3. PCI DSS Validation

**This AOC is based on results noted in SAQ D (Section 2), dated (Self-assessment completion date** *YYYY-MM-DD).*

Indicate below whether a full or partial PCI DSS assessment was completed:

   ___ **Full** – All requirements have been assessed therefore no requirements were marked as Not
       Tested in the SAQ.

   ___ **Partial** – One or more requirements have not been assessed and were therefore marked as Not
       Tested in the SAQ. Any requirement not assessed is noted as Not Tested in Part 2g above.

Based on the results documented in the SAQ D noted above, each signatory identified in any of Parts 3b–3d,
as applicable, assert(s) the following compliance status for the merchant identified in Part 2 of this document.

*Select one:*

___ **Compliant:** All sections of the PCI DSS SAQ are complete, and all assessed requirements are
    marked as being either 1) In Place, 2) In Place with Remediation, or 3) Not Applicable, resulting in
    an overall **COMPLIANT** rating; thereby *(Merchant Company Name)* has demonstrated compliance
    with all PCI DSS requirements included in this SAQ except those noted as Not Tested above.

___ **Non-Compliant:** Not all sections of the PCI DSS SAQ are complete, or one or more requirements
    are marked as Not in Place, resulting in an overall **NON-COMPLIANT** rating, thereby *(Merchant
    Company Name)* has not demonstrated compliance with the PCI DSS requirements included in this
    SAQ.

    **Target Date** for Compliance: *YYYY-MM-DD*

    A merchant submitting this form with a Non-Compliant status may be required to complete the
    Action Plan in Part 4 of this document. Confirm with the entity to which this AOC will be submitted
    *before completing Part 4.*

___ **Compliant but with Legal exception:** One or more assessed requirements in the PCI DSS SAQ
    are marked as Not in Place due to a legal restriction that prevents the requirement from being met
    and all other assessed requirements are marked as being either 1) In Place, 2) In Place with
    Remediation, or 3) Not Applicable, resulting in an overall **COMPLIANT BUT WITH LEGAL
    EXCEPTION** rating; thereby *(Merchant Company Name)* has demonstrated compliance with all PCI
    DSS requirements included in this SAQ except those noted as Not Tested above or as Not in Place
    due to a legal restriction.

    This option requires additional review from the entity to which this AOC will be submitted. *If
    selected, complete the following:*

    Affected Requirement          Details of how legal constraint prevents
                                        requirement from being met




*PCI DSS v4.0 SAQ D for Merchants, Section 3: AOC Validation and Attestation Details*                April 2022
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                              Page 107

--- page 117 ---

Part 3a. Merchant Acknowledgement

Signatory(s) confirms:
*(Select all that apply)*

   ___ PCI DSS Self-Assessment Questionnaire D, Version 4.0 was completed according to the instructions
       therein.

   ___ All information within the above-referenced SAQ and in this attestation fairly represents the results of
       the merchant's assessment in all material respects.

   ___ PCI DSS controls will be maintained at all times, as applicable to the merchant's environment.

Part 3b. Merchant Attestation

*Signature of Merchant Executive Officer ↑*                    *Date: YYYY-MM-DD*
*Merchant Executive Officer Name:*                             *Title:*

Part 3c. Qualified Security Assessor (QSA) Acknowledgement

If a QSA was involved or assisted with     ___ QSA performed testing procedures.
this assessment, indicate the role
performed:                                 ___ QSA provided other assistance.
                                           If selected, describe all role(s) performed:

*Signature of Lead QSA ↑*                                      *Date: YYYY-MM-DD*
Lead QSA Name:

*Signature of Duly Authorized Officer of QSA Company ↑*        *Date: YYYY-MM-DD*
*Duly Authorized Officer Name:*                                *QSA Company:*

Part 3d. PCI SSC Internal Security Assessor (ISA) Involvement

If an ISA(s) was involved or assisted with    ___ ISA(s) performed testing procedures.
this assessment, indicate the role
performed:                                    ___ ISA(s) provided other assistance.
                                              If selected, describe all role(s) performed:

*PCI DSS v4.0 SAQ D for Merchants, Section 3: AOC Validation and Attestation Details*                    *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                                  *Page 108*

--- page 118 ---

Part 4. Action Plan for Non-Compliant Requirements

*Only complete Part 4 upon request of the entity to which this AOC will be submitted, and only if the Assessment has a Non-Compliant status noted in Section 3.*

If asked to complete this section, select the appropriate response for "Compliant to PCI DSS Requirements" for each requirement below. For any "No" responses, include the date the merchant expects to be compliant with the requirement and a brief description of the actions being taken to meet the requirement.

 PCI DSS          Description of Requirement             Compliant to PCI        Remediation Date and
 Requirement                                             DSS Requirements              Actions
                                                           (Select One)          (If "NO" selected for any
                                                         YES          NO              Requirement)

 1                Install and maintain network security   □            □
                  controls

 2                Apply secure configurations to all      □            □
                  system components

 3                Protect stored account data             □            □

 4                Protect cardholder data with strong     □            □
                  cryptography during transmission over
                  open, public networks

 5                Protect all systems and networks from   □            □
                  malicious software

 6                Develop and maintain secure systems     □            □
                  and software

 7                Restrict access to system components    □            □
                  and cardholder data by business need to
                  know

 8                Identify users and authenticate access  □            □
                  to system components

 9                Restrict physical access to cardholder  □            □
                  data

 10               Log and monitor all access to system    □            □
                  components and cardholder data

 11               Test security systems and networks      □            □
                  regularly

 12               Support information security with       □            □
                  organizational policies and programs

 Appendix A2      Additional PCI DSS Requirements for     □            □
                  Entities using SSL/Early TLS for Card-
                  Present POS POI Terminal Connections

*PCI DSS v4.0 SAQ D for Merchants, Section 3: AOC Validation and Attestation Details*                    *April 2022*
*© 2006-2022 PCI Security Standards Council, LLC. All Rights Reserved.*                                  *Page 109*
