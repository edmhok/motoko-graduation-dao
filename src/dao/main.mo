import Result "mo:base/Result";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Types "types";
import MBToken "mo:base/MBToken";

actor DAO {

    type Result<A, B> = Result.Result<A, B>;
    type Member = Types.Member;
    type ProposalContent = Types.ProposalContent;
    type ProposalId = Types.ProposalId;
    type Proposal = Types.Proposal;
    type Vote = Types.Vote;
    type HttpRequest = Types.HttpRequest;
    type HttpResponse = Types.HttpResponse;

    stable var manifesto = "Your manifesto";
    stable let name = "Your DAO";

    // A list to store members
    private var members : [Member] = [];
    private let student1Principal = Principal.fromText("4ey3h-nplzm-vyocb-xfjab-wwsos-ejl4y-27juy-qresy-emn7o-eczpl-pae");
    private let student2Principal = Principal.fromText("im5mh-xqo25-qfehz-urydn-n7fpm-ylmaw-n6fld-h2xdx-46pcp-tcuti-eqe");
    private var student3Principal = Principal.fromText(""); // Placeholder for owner's principal, to be set in init

    // A list to store proposals
    private var proposals : [Proposal] = [];
    private var nextProposalId : Nat = 0;

    // Returns the name of the DAO
    public query func getName() : async Text {
        return name;
    };

    // Returns the manifesto of the DAO
    public query func getManifesto() : async Text {
        return manifesto;
    };

    // Register a new member in the DAO
    public shared ({ caller }) func registerMember(memberName : Text) : async Result<(), Text> {
        if (members.filter(func(member : Member) : Bool { member.id == caller }).isEmpty()) {
            members := members + [{
                id = caller;
                name = memberName;
                role = #Student; // Default role for new members
            }];
            return #ok(());
        } else {
            return #err("Member already exists");
        };
    };

    // Initialize function to set the owner's principal as Student 3
    public func init(owner : Principal) {
        // ... [rest of the initialization logic]

        // Set the owner's principal as Student 3's principal
        student3Principal := owner;
    };

    // Function to get a member's details by their principal ID
    public query func getMember(p : Principal) : async Result<Member, Text> {
        if (p == student1Principal | | p == student2Principal | | p == student3Principal) {
            let filteredMembers = members.filter(func(member : Member) : Bool { member.id == p });
            if (filteredMembers.isEmpty()) {
                return #err("Member not found");
            } else {
                return #ok(filteredMembers[0]);
            };
        } else {
            return #err("Principal ID does not match Student 1, 2, or 3");
        };
    };

    // Graduate the student with the given principal
    public shared ({ caller }) func graduate(student : Principal) : async Result<(), Text> {
        for (var i = 0, i < members.size(), i += 1) {
            if (members[i].id == student & & members[i].role == #Student) {
                members[i].role := #Graduate;
                return #ok(());
            };
        };
        return #err("Student not found or not a student");
    };

    // Create a new proposal
    public shared ({ caller }) func createProposal(content : ProposalContent) : async Result<ProposalId, Text> {
        let newProposalId = nextProposalId;
        proposals := proposals + [{
            id = newProposalId;
            content = content;
            createdBy = caller;
            votesFor = 0;
            votesAgainst = 0;
        }];
        nextProposalId += 1;
        return #ok(newProposalId);
    };

    // Other necessary functions...

    // Voting functionality and other logic goes here...
};
