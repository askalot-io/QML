qmlVersion: '1.0'
questionnaire:
  title: 12 Wellbeing Stress
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    age: range(12, 120)
    # GEN_Q08: Worked in past 12 months (0=No, 1=Yes) — from 02_general_health
    gen_q08_worked: {0, 1}
  blocks:
  - id: b_satisfaction
    title: Satisfaction with Life
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_swl_intro
      kind: Comment
      title: Now I'd like to ask about your satisfaction with various aspects of your life. Please tell me whether you are
        very satisfied, satisfied, neither satisfied nor dissatisfied, dissatisfied, or very dissatisfied.
    - id: q_swl_q02
      kind: Question
      title: How satisfied are you with your job or main activity?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q03
      kind: Question
      title: How satisfied are you with your leisure activities?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q04
      kind: Question
      title: How satisfied are you with your financial situation?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q05
      kind: Question
      title: How satisfied are you with yourself?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q06
      kind: Question
      title: How satisfied are you with the way your body looks?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q07
      kind: Question
      title: How satisfied are you with your relationships with other family members?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q08
      kind: Question
      title: How satisfied are you with your relationships with friends?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q09
      kind: Question
      title: How satisfied are you with your housing?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
    - id: q_swl_q10
      kind: Question
      title: How satisfied are you with your neighbourhood?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Neither satisfied nor dissatisfied
          4: Dissatisfied
          5: Very dissatisfied
  - id: b_stress_sources
    title: Stress Sources
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_sts_intro
      kind: Comment
      title: Now a few questions about the stress in your life.
    - id: q_sts_q1
      kind: Question
      title: 'In general, how would you rate your ability to handle unexpected and difficult problems, for example, a family
        or personal crisis? Would you say your ability is:'
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very good
          3: Good
          4: Fair
          5: Poor
    - id: q_sts_q2
      kind: Question
      title: 'In general, how would you rate your ability to handle the day-to-day demands in your life, for example, handling
        work, family and volunteer responsibilities? Would you say your ability is:'
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very good
          3: Good
          4: Fair
          5: Poor
    - id: q_sts_q3
      kind: Question
      title: Thinking about stress in your day-to-day life, what would you say is the most important thing contributing to
        feelings of stress you may have?
      input:
        control: Radio
        labels:
          1: Time pressures / not enough time
          2: Own physical health problem or condition
          3: Own emotional or mental health problem or condition
          4: Financial situation
          5: Own work situation
          6: School
          7: Employment status
          8: Caring for own children
          9: Caring for others
          10: Other personal or family responsibilities
          11: Personal relationships
          12: Discrimination
          13: Personal and family's safety
          14: Health of family members
          15: Other
          16: Nothing
    - id: q_sts_q3s
      kind: Question
      title: Please specify the other source of stress.
      precondition:
      - predicate: q_sts_q3.outcome == 15
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_stress_coping
    title: Stress Coping
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_stc_intro
      kind: Comment
      title: Now a few questions about coping with stress.
    - id: q_stc_q1_1
      kind: Question
      title: How often do you try to solve the problem?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_2
      kind: Question
      title: To deal with stress, how often do you talk to others?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_3
      kind: Question
      title: When dealing with stress, how often do you avoid being with people?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_4
      kind: Question
      title: How often do you sleep more than usual to deal with stress?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_5a
      kind: Question
      title: When dealing with stress, how often do you try to feel better by eating more, or less, than usual?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_5b
      kind: Question
      title: When dealing with stress, how often do you try to feel better by smoking more cigarettes than usual?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
          5: Do not smoke
    - id: q_stc_q1_5c
      kind: Question
      title: When dealing with stress, how often do you try to feel better by drinking alcohol?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_5d
      kind: Question
      title: When dealing with stress, how often do you try to feel better by using drugs or medication?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_6
      kind: Question
      title: How often do you jog or do other exercise to deal with stress?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_7
      kind: Question
      title: How often do you pray or seek spiritual help to deal with stress?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_8
      kind: Question
      title: To deal with stress, how often do you try to relax by doing something enjoyable?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_9
      kind: Question
      title: To deal with stress, how often do you try to look on the bright side of things?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_10
      kind: Question
      title: How often do you blame yourself?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
    - id: q_stc_q1_11
      kind: Question
      title: To deal with stress, how often do you wish the situation would go away or somehow be finished?
      input:
        control: Radio
        labels:
          1: Often
          2: Sometimes
          3: Rarely
          4: Never
  - id: b_childhood_stressors
    title: Childhood and Adult Stressors
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 18
    items:
    - id: q_cst_intro
      kind: Comment
      title: The next few questions ask about some things that may have happened to you while you were a child or a teenager,
        before you moved out of the house. Please tell me if any of these things have happened to you.
    - id: q_cst_q1
      kind: Question
      title: Did you spend 2 weeks or more in the hospital?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q2
      kind: Question
      title: Did your parents get a divorce?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q3
      kind: Question
      title: Did your father or mother not have a job for a long time when they wanted to be working?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q4
      kind: Question
      title: Did something happen that scared you so much you thought about it for years after?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q5
      kind: Question
      title: Were you sent away from home because you did something wrong?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q6
      kind: Question
      title: Did either of your parents drink or use drugs so often that it caused problems for the family?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_cst_q7
      kind: Question
      title: Were you ever physically abused by someone close to you?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_work_stress
    title: Work Stress
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15 and age <= 75
    - predicate: gen_q08_worked == 1
    items:
    - id: q_wst_intro
      kind: Comment
      title: The next few questions are about your main job or business in the past 12 months. I'm going to read you a series
        of statements that might describe your job situation. Please tell me if you strongly agree, agree, neither agree nor
        disagree, disagree, or strongly disagree.
    - id: q_wst_q401
      kind: Question
      title: Your job required that you learn new things.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q402
      kind: Question
      title: Your job required a high level of skill.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q403
      kind: Question
      title: Your job allowed you freedom to decide how you did your job.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q404
      kind: Question
      title: Your job required that you do things over and over.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q405
      kind: Question
      title: Your job was very hectic.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q406
      kind: Question
      title: You were free from conflicting demands that others made.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q407
      kind: Question
      title: Your job security was good.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q408
      kind: Question
      title: Your job required a lot of physical effort.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q409
      kind: Question
      title: You had a lot to say about what happened in your job.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q410
      kind: Question
      title: You were exposed to hostility or conflict from the people you worked with.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q411
      kind: Question
      title: Your supervisor was helpful in getting the job done.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q412
      kind: Question
      title: The people you worked with were helpful in getting the job done.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q412a
      kind: Question
      title: You had the materials and equipment you needed to do your job.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_wst_q413
      kind: Question
      title: How satisfied were you with your job?
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Not too satisfied
          4: Not at all satisfied
  - id: b_self_esteem
    title: Self-Esteem
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_sfe_intro
      kind: Comment
      title: Now a series of statements that people might use to describe themselves. Please tell me if you strongly agree,
        agree, neither agree nor disagree, disagree, or strongly disagree.
    - id: q_sfe_q501
      kind: Question
      title: You feel that you have a number of good qualities.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sfe_q502
      kind: Question
      title: You feel that you're a person of worth at least equal to others.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sfe_q503
      kind: Question
      title: You are able to do things as well as most other people.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sfe_q504
      kind: Question
      title: You take a positive attitude toward yourself.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sfe_q505
      kind: Question
      title: On the whole you are satisfied with yourself.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sfe_q506
      kind: Question
      title: All in all, you're inclined to feel you're a failure.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
