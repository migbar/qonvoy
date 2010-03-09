class TwitterQueue
  class << self
    def reset
      @@queue = nil
      @@friendships = nil
    end
    
    def friendships
      @@friendships ||= Hash.new([])
    end
    
    def queue
      @@queue ||= {}
    end
    
    def add(screen_name, status)
      for_user(screen_name) << status.to_s
    end
    
    def add_dm(sender, recipient, message)
      RatingBird.receive_direct_message(Hashie::Mash.new({
        :sender_screen_name => sender,
        :recipient_screen_name => recipient,
        :text => message
      }))
    end
    
    def for_user(screen_name)
      queue[screen_name] ||= []
    end
  end
end