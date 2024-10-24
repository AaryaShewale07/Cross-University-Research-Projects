module CrossUniversity::ResearchCollaboration {
    use aptos_framework::signer;
    use std::string::String;

    /// Struct representing a research project
    struct ResearchProject has key, store {
        lead_university: address,
        project_name: String,
        participants: vector<address>,
        is_active: bool
    }

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_PROJECT_ALREADY_EXISTS: u64 = 2;
    const E_PROJECT_NOT_FOUND: u64 = 3;
    const E_ALREADY_PARTICIPATING: u64 = 4;

    /// Create a new research project
    public fun create_project(
        creator: &signer,
        project_name: String
    ) {
        let creator_addr = signer::address_of(creator);
        
        // Create new project
        let project = ResearchProject {
            lead_university: creator_addr,
            project_name,
            participants: vector::singleton(creator_addr),
            is_active: true
        };
        
        move_to(creator, project);
    }

    /// Join an existing research project
    public fun join_project(
        participant: &signer,
        lead_university: address
    ) acquires ResearchProject {
        let participant_addr = signer::address_of(participant);
        
        // Get project reference
        let project = borrow_global_mut<ResearchProject>(lead_university);
        assert!(project.is_active, E_PROJECT_NOT_FOUND);
        assert!(!vector::contains(&project.participants, &participant_addr), E_ALREADY_PARTICIPATING);
        
        // Add participant
        vector::push_back(&mut project.participants, participant_addr);
    }
}