# require 'Money'
require 'csv'
#require_relative './support/accounts'
module Bank
 class Account
   attr_accessor :balance, :owner, :accounts_hash
   attr_reader :id

   def initialize(id_number, initial_balance, account_date)
     unless initial_balance.to_f > 0
       raise ArgumentError.new("Account must have money in it.")
     end
     @id = id_number
     @balance = initial_balance
     @account_date = account_date
   end

  def self.pull_from_csv
  CSV.read('./support/accounts.csv')
  end

  def self.all
    accounts_hash = {}
    self.pull_from_csv.each do |account|
      new_account = Bank::Account.new(account[0], account[1].to_f , account[2])
      id = account[0]
      accounts_hash[id] = new_account
    end
      accounts_hash
  end

   def withdraw(amount)
     if amount > @balance
       puts "Warning: requested amount is greater than available balance. Please make another selection."
       return @balance
     else
       @balance = @balance - amount
     end
   end

   def deposit(amount)
     @balance = @balance + amount
   end

   def self.find(id)
     self.all.each do |account|
       if account[0] == id
         return account
       end
     end
   end

 end


 class Owner
   attr_reader :id, :name, :address, :city, :state

   def initialize(owner_hash)
     @name = owner_hash[:first_name] + owner_hash[:last_name]
     @owner_number = owner_hash[:customer_number]
     @address = owner_hash[:address]
     @city = owner_hash[:city]
     @state = owner_hash[:state]
   end

   def self.pull_from_csv
     CSV.read('./support/owners.csv')
   end

   def self.all
     owners_hash = {}
     self.pull_from_csv.each do |account|
       new_owner = {
         customer_number: account[0],
         first_name: account[2],
         last_name: account[1],
         address: account[3],
         city: account[4],
         state: account[5]
       }
       owner_number = account[0]
       new_account = Bank::Owner.new(new_owner)
       owners_hash[owner_number] = new_account
     end
      return owners_hash
   end

   def self.find(id)
     owner_number = self.find_owner_number(id)
     puts owner_number
     self.all.each do |key, value|
       if key == owner_number
         return value
       end
     end
   end

   def self.find_owner_number(id) #search accounts by id number
     owner_list = CSV.read('./support/account_owners.csv')
     owner_list.each do |account|
       puts account
      if account[0] == id.to_s
        puts "This is the number associated with #{id}'s account"
        return account[1] #returns owner number
      end
    end
   end

    # def self.find_owner_info_with_number(id) #USER COMMAND TO FIND OWNER
    #   owner_number = self.find_owner_number(id)
    #   owner_list = CSV.read('./support/account_owners.csv')
    #   owner_list.each do |owner|
    #     if owner[1] == owner_number
    #       return owner_number
    #       puts "OWNER ID #{id} belongs to owner #{owner_number}"
    #     end
    #   end
    # end

 end


end
