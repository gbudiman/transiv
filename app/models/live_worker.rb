class LiveWorker
  include Sidekiq::Worker

  def perform(*args)
    case args[0]
    when 'feed'
      perform_feed(args[1], args[2], args[3], args[4])
    end
  end

  def perform_feed(base_uri, agency, stop_id, stop_gtfs_id)
    LiveFeed.get base_uri: base_uri, 
                 agency: agency, 
                 stop_id: stop_id, 
                 stop_gtfs_id: stop_gtfs_id
  end
end
