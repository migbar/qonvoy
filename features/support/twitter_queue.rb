class TwitterQueue
  class << self
    def reset
      @@queue = nil
      @@friendships = nil
      @@updates = nil
    end
    
    def friendships
      @@friendships ||= Hash.new([])
    end
    
    #twitter queue (incoming)
    def queue 
      @@queue ||= {}
    end
    
    def for_user(screen_name)
      queue[screen_name] ||= []
    end
    
    def text_queue(screen_name)
      queue[screen_name].inject([]) do |acc, status|
        acc << status[:text]
        acc
      end
    end
    
    #twitter statuses (outgoing)
    def updates
      @@updates ||= Hash.new([])
    end
    
    def update_status(screen_name, status)
      updates[screen_name] << status.to_s
    end
    
    def status_for(screen_name)
      updates[screen_name].last
    end
    
    def add(screen_name, status, sender=nil)
      for_user(screen_name) << {
        :sender_screen_name => sender,
        :text => status.to_s
      }
      
      if sender
        update_status(sender, status.to_s)
      end
    end
    
    def add_dm(sender, recipient, message)
      RatingBird.receive_direct_message(Hashie::Mash.new({
        :sender_screen_name => sender.screen_name,
        :sender_id => sender.twitter_uid,
        :recipient_screen_name => recipient,
        :text => message
      }))
    end
  end
end