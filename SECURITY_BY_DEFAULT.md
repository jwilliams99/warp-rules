•  Priority: CRITICAL
•  Importance: EXTREME
•  Never Ignore: true
•  Description:  
  Security must be designed into systems from inception, not bolted on afterward
•  Enforcement: mandatory_security_review_before_deployment
•  Philosophy:  
  security_is_not_a_feature_it_is_foundational_requirement

Approach

Existing Systems:

•  Step 1: understand_current_security_mechanisms
•  Step 2: document_existing_patterns_and_infrastructure
•  Step 3: reuse_and_extend_existing_security_controls
•  Step 4: maintain_consistency_with_established_patterns
•  Rationale:  
  leverage_existing_tested_security_infrastructure_avoid_fragmentation

New Systems:

•  Step 1: security_architecture_planning_during_initial_design
•  Step 2: incorporate_security_into_technical_plan_document
•  Step 3: implement_security_controls_as_foundational_components
•  Step 4: make_security_part_of_system_dna_not_afterthought
•  Rationale:  
  security_by_design_is_more_effective_than_security_by_retrofit

Mandatory Controls

Input Validation:

•  Requirement: validate_all_user_inputs
•  Scope: every_endpoint_every_input_field
•  Techniques:
◦  type_checking
◦  length_limits
◦  format_validation
◦  whitelist_over_blacklist
◦  sanitization_where_appropriate
•  Enforcement: reject_invalid_input_never_trust_client_data