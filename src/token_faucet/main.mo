import Result "mo:base/Result";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Map "mo:map/Map";

import { phash } "mo:map/Map";

actor MBToken {

  public type Result<A, B> = Result.Result<A, B>;

  // Ledger to track token balances
  let ledger = Map.new<Principal, Nat>();

  // Function to return the token name
  public query func tokenName() : async Text {
    return "Motoko Bootcamp Token";
  };

  // Function to return the token symbol
  public query func tokenSymbol() : async Text {
    return "MBT";
  };

  // Function to mint new tokens
  public func mint(owner : Principal, amount : Nat) : async Result<(), Text> {
    let balance = Option.get(Map.get<Principal, Nat>(ledger, phash, owner), 0);
    Map.set<Principal, Nat>(ledger, phash, owner, balance + amount);
    return #ok();
  };

  // Function to burn tokens
  public func burn(owner : Principal, amount : Nat) : async Result<(), Text> {
    let balance = Option.get(Map.get<Principal, Nat>(ledger, phash, owner), 0);
    if (balance < amount) {
      return #err("Insufficient balance to burn");
    };
    Map.set<Principal, Nat>(ledger, phash, owner, balance - amount);
    return #ok();
  };

  // Function to get the balance of a token owner
  public query func balanceOf(owner : Principal) : async Nat {
    return Option.get(Map.get<Principal, Nat>(ledger, phash, owner), 0);
  };

  // Function to get the balances of multiple owners
  public query func balanceOfArray(owners : [Principal]) : async [Nat] {
    var balances = Map.map<Principal, Nat>(owners, (owner) = > Option.get(Map.get<Principal, Nat>(ledger, phash, owner), 0));
    return balances;
  };

  // Function to get the total supply of tokens
  public query func totalSupply() : async Nat {
    var total = 0;
    for (balance in Map.vals<Principal, Nat>(ledger)) {
      total += balance;
    };
    return total;
  };

  // Function to transfer tokens
  public shared ({ caller }) func transfer(from : Principal, to : Principal, amount : Nat) : async Result<(), Text> {
    let balanceFrom = Option.get(Map.get<Principal, Nat>(ledger, phash, from), 0);
    let balanceTo = Option.get(Map.get<Principal, Nat>(ledger, phash, to), 0);
    if (balanceFrom < amount) {
      return #err("Insufficient balance to transfer");
    };
    Map.set<Principal, Nat>(ledger, phash, from, balanceFrom - amount);
    Map.set<Principal, Nat>(ledger, phash, to, balanceTo + amount);
    return #ok();
  };

  // Additional token-related functionalities...
};
