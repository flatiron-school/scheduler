def videos
  [
    "[Intro to Git](https://www.youtube.com/watch?v=bK7i-BMJcM0&feature=youtu.be)",
   "[Intro to Ruby](https://www.youtube.com/watch?v=_BmEuwgHsGI&feature=youtu.be)",
   "[Intro to Object Orientation](https://www.youtube.com/watch?v=bBtFLt8nBng&feature=youtu.be)",
   "[Intro to Object Relations and Self](https://www.youtube.com/watch?v=Vrj1opkvTs8&feature=youtu.be)",
   "[Moronic Monday, Week 2](https://www.youtube.com/watch?v=Gd_s7CwW2MA&feature=youtu.be)",
   "[Sharing Code](http://youtu.be/A9_ZEgEeG-8)",
   "[Intro to SQL](https://www.youtube.com/watch?v=oUqFqhsQLPk)",
   "[More SQL](https://www.youtube.com/watch?v=gpwbDUhxFG4)",
   "[Intro to ORMs](http://youtu.be/8Tx0C-FIDU8)",
   "[HacktiveRecord](http://youtu.be/RtgMqhRX5ek)",
   "[ActiveRecord Gem](https://www.youtube.com/watch?v=EhhUGQIma_A&feature=youtu.be)",
   "[Migrations](https://www.youtube.com/watch?v=EhhUGQIma_A&feature=youtu.be)",
   "[The Internet](https://www.youtube.com/watch?v=P--x-P44IH4&feature=youtu.be)",
   "[Rack Routes](https://www.youtube.com/watch?v=0pUQzJN5exw&feature=youtu.be)",
   "[Rack Routes & Intro to Sinatra](http://youtu.be/c0m3QIBdock)",
   "[Intro to Forms](http://youtu.be/mc_kCLw_jBA)",
   "[Intro to Rails](https://www.youtube.com/watch?v=fpHd9bE2o7o&feature=youtu.be)",
   "[Building with Rails - HackKey](http://youtu.be/ACEQuKpyX5k)",
   "[Building with TTrackr](https://www.youtube.com/watch?v=lObHElZAxnc&feature=youtu.be)",
   "[Nested Forms - Part 1](https://www.youtube.com/watch?v=Etc-IsokyI8&feature=youtu.be)",
   "[Nested Forms - Part 2](https://www.youtube.com/watch?v=Q14udTLt5YE&feature=youtu.be)",
   "[Authentication](https://www.youtube.com/watch?v=5fcQu-j7mDA&feature=youtu.be)",
   "[Sign in and Sign up](https://www.youtube.com/watch?v=uqCwlyhbon4&feature=youtu.be)",
   "[Sign out and Before_action](https://www.youtube.com/watch?v=w6LbZbcdYdg&feature=youtu.be)"
]
end

def split_on_link(videos)
  videos.collect { |str| str.split(/(?=http)/) }.flatten!
end

def remove_markdown(videos)
  videos.collect { |str| str.tr('[]', "") }.collect { |str| str.tr('()', "") }
end

def create_video_hash(videos)
  hash = {}
    videos.each do |x|
      if videos.index(x).even?
        hash[x]
      else
        index = videos.index(x) - 1
        hash[videos[index]] = x
    end
  end
    hash
    hash.keep_if { |key,value| key.is_a? String }
end

def create_videos(hash)
  cohort = Cohort.find(2)

  hash.each do |title, link|
    Video.create(title: title, link: link, cohort: cohort)
  end
  cohort.save
end

split_videos = split_on_link(videos)
ready_videos = remove_markdown(split_videos)
hash = create_video_hash(ready_videos)

create_videos(hash)
