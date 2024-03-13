import Principal "mo:base/Principal";
import Time "mo:base/Time";

module {
    // Define a Role type for members
    public type Role = {
        #Student;
        #Graduate;
        #Mentor;
    };

    // Member structure with name, role, and principal
    public type Member = {
        id : Principal;
        name : Text;
        role : Role;
    };

    // Define a Proposal ID type
    public type ProposalId = Nat;

    // Define the content of proposals
    public type ProposalContent = {
        #ChangeManifesto : Text; // Change the manifesto text
        #AddMentor : Principal; // Upgrade a member to a mentor
        // Other proposal types can be added here
    };

    // Define Proposal Status
    public type ProposalStatus = {
        #Open;
        #Accepted;
        #Rejected;
    };

    // Define a Vote type
    public type Vote = {
        member : Principal; // The member who voted
        vote : Bool; // true for yes, false for no
    };

    // Define a Proposal structure
    public type Proposal = {
        id : ProposalId;
        content : ProposalContent;
        createdBy : Principal;
        createdOn : Time.Time;
        status : ProposalStatus;
        votes : [Vote];
        // Additional fields can be added here
    };

    // HTTP Request and Response types for potential web integration
    public type HttpRequest = {
        method : Text;
        url : Text;
        headers : [(Text, Text)];
        body : Blob;
    };

    public type HttpResponse = {
        status_code : Nat16;
        headers : [(Text, Text)];
        body : Blob;
    };
};
