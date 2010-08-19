require 'spec_helper'

describe Graph::UserNode do
	
	before(:each) do
	  Neo4j::Transaction.new
	end
	
	after(:each) do
	  Neo4j::Transaction.finish
	end
	
  describe "#update_follows" do
    let(:friends)           { persistent_friends + new_friends }
		let(:new_friends)       { [ Factory.create(:twitter_user) ] }
		let(:persistent_friends) { [ Factory.create(:twitter_user) ] }
		let(:existing_friends)  { persistent_friends + former_friends }
		let(:former_friends)    { [ Factory.create(:twitter_user) ] }
		
		before(:each) do
	  	existing_friends.each do |f|
				subject.add_follows(f)
		  end
		end

		it "creates follows relationships with new friends" do
		  subject.update_follows(friends)
			friend_ids = subject.follows.map(&:user_id)
			
			new_friends.each do |f|
				friend_ids.should include(f.id)
			end
		end
		
		it "keeps the persistent friends" do
		  subject.update_follows(friends)
			friend_ids = subject.follows.map(&:user_id)
			
			persistent_friends.each do |f|
				friend_ids.should include(f.id)
			end
		end
		
		it "deletes follows relationships with former friends" do
		  subject.update_follows(friends)
			friend_ids = subject.follows.map(&:user_id)
			
			former_friends.each do |f|
				friend_ids.should_not include(f.id)
			end
		end
  end
end
