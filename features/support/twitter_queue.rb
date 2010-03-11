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
    
    def text_queue(screen_name)
      queue[screen_name].inject([]) do |acc, status|
        acc << status[:text]
        acc
      end
    end
    
    def add(screen_name, status, sender=nil)
      for_user(screen_name) << {
        :sender_screen_name => sender,
        :text => status.to_s
      }
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