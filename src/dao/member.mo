import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

actor class DAO() = this {


    public type Member = {
        name : Text;
        age : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let members = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func whoami() : async Text {
        return Principal.toText(caller);
    };

    public shared ({ caller }) func getPassword() : async Text {
        if (Principal.toText(caller) == "iib2i-y6c5c-z6zw7-a44us-hmc7e-sgrwa-hfb4r-idf5z-yg2lz-ua5ce-6ae") {
            return "The password is 123";
        } else {
            return "You don't have access to the password";
        };
    };

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        let principalID = caller;
        switch (members.get(principalID)) {
            // Case where there is no member for the given principal
            case (null) {
                members.put(principalID, member);
                return #ok();
            };
            // Case where there is already a member with the given principal
            case (?existingMember) {
                return #err("There is already a member associated with the Principal:" # Principal.toText(principalID) # " " # " the name of the member is : " # existingMember.name);
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch (members.get(p)) {
            case (null) {
                return #err("There is no member associated with the Principal : " # Principal.toText(p));
            };
            case (?existingMember) {
                return #ok(existingMember);
            };

        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        switch (members.get(caller)) {
            case (null) {
                return #err("There is no member associated with the Principal : " # Principal.toText(caller));
            };
            case (?existingMember) {
                members.put(caller, member);
                return #ok();
            };

        };
    };

    public query func getAllMembers() : async [Member] {
        return Iter.toArray(members.vals());
    };

    public query func numberOfMembers() : async Nat {
        return members.size();
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (members.get(caller)) {
            case (null) {
                return #err("There is no member associated with the Principal : " # Principal.toText(caller));
            };
            case (?existingMember) {
                members.delete(caller);
                return #ok();
            };

        };
    };

};
