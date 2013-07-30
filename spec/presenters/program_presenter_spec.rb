require "spec_helper"

describe ProgramPresenter do
  describe "#teaser" do
    it "returns html_safe teaser if it's present" do
      program = build :kpcc_program, teaser: "This is <b>cool</b> teaser, bro."
      p = presenter(program)
      p.teaser.should eq "This is <b>cool</b> teaser, bro."
      p.teaser.html_safe?.should be_true
    end

    it "returns nil if teaser not present" do
      program = build :kpcc_program, teaser: nil
      p = presenter(program)
      p.teaser.should eq nil
    end
  end

  #--------------------

  describe "#description" do
    it "returns html_safe description if it's present" do
      program = build :kpcc_program, description: "This is <b>cool</b> description, bro."
      p = presenter(program)
      p.description.should eq "This is <b>cool</b> description, bro."
      p.description.html_safe?.should be_true
    end

    it "returns nil if description not present" do
      program = build :kpcc_program, description: nil
      p = presenter(program)
      p.description.should eq nil
    end
  end

  #--------------------

  describe "#web_link" do
    it "returns program.web_url if specified" do
      program = build :external_program
      program.related_links.build(title: "Website", url: "scpr.org/airtalk", link_type: "website")
      p = presenter(program)
      p.web_link.should match %r{scpr\.org/airtalk}
    end

    it "returns nil if not specified" do
      program = build :external_program
      p = presenter(program)
      p.web_link.should eq nil
    end
  end

  describe "#podcast_link" do
    context "for external programs" do
      it "returns program.podcast_url if specified" do
        program = build :external_program, podcast_url: "podcast.com/airtalk"
        p = presenter(program)
        p.podcast_link.should match %r{podcast\.com/airtalk}
      end

      it "returns nil if no podcast_url present" do
        program = build :external_program, podcast_url: nil
        p = presenter(program)
        p.podcast_link.should eq nil
      end
    end

    context "for kpcc programs" do
      it "gets podcast related link for kpcc programs" do
        program = build :kpcc_program
        program.related_links.build(title: "Podcast", url: "http://podcast.com/airtalk", link_type: "podcast")
        p = presenter(program)
        p.podcast_link.should match %r{podcast\.com/airtalk}
      end

      it "returns nil if no podcast link present" do
        program = build :kpcc_program
        p = presenter(program)
        p.podcast_link.should eq nil
      end
    end
  end

  describe "#rss_link" do
    it "returns program.rss_url if specified" do
      program = build :external_program
      program.related_links.build(title: "RSS", url: "show.com/airtalk", link_type: "rss")
      p = presenter(program)
      p.rss_link.should match %r{show\.com/airtalk}
    end

    it "returns nil if not specified" do
      program = build :external_program
      p = presenter(program)
      p.rss_link.should eq nil
    end
  end


  describe "#facebook_link" do
    it "returns the facebook link if specified" do
      program = build :kpcc_program
      program.related_links.build(title: "Facebook", url: "facebook.com/airtalk", link_type: "facebook")
      p = presenter(program)
      p.facebook_link.should match %r{facebook\.com/airtalk}
    end

    it "returns nil if not specified" do
      program = build :kpcc_program
      p = presenter(program)
      p.facebook_link.should eq nil
    end
  end

  describe "#twitter_link" do
    it "returns the twitter url if twitter handle is presen t" do
      program = build :kpcc_program, twitter_handle: "airtalk"
      p = presenter(program)
      p.twitter_link.should match %r{twitter\.com/airtalk}
    end

    it "returns nil if not specified" do
      program = build :kpcc_program, twitter_handle: ""
      p = presenter(program)
      p.twitter_link.should eq nil
    end
  end
end
