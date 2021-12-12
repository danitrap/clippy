FROM danitrap/ruby:1.9.3-p551-onbuild

ENV REDISTOGO_URL=redis://redis:6379
CMD bundle exec ruby app.rb -p 3000