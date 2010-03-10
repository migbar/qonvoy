require 'spec_helper'

describe StatusParser do
  describe ".parse" do
    messages = {
      "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => "Awesome"
      },
      "Shrimp Noodle Soup from Nobu - 8 out of 10" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      "Shrimp Noodle Soup from Nobu: 8 out of 10" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      "Shrimp Noodle Soup from Nobu, 8 out of 10" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      "Shrimp Noodle Soup from Nobu 8 out of 10" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      "Soup from Nobu 8 out of 10" => {
        :dish => "Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      "Soup from Nobu Restaurant 8 out of 10" => {
        :dish => "Soup", :place => "Nobu Restaurant", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      },
      # "Soup from Nobu Restaurant 8/10" => {
      #   :dish => "Soup", :place => "Nobu Restaurant", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      # },
      "8/10 for the Shrimp Noodle Soup at Nobu" => {
        :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8", :scale => "10", :type => :rating, :qualifier => nil
      }
    }
    
    messages.each do |body, result|
      it "parses '#{body}' into #{result.inspect}" do
        StatusParser.parse(body).should == result
      end
    end
  end
end
