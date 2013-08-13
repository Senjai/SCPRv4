# encoding: UTF-8
class PopularTwitterForExternalPrograms < ActiveRecord::Migration
  def up
    str = <<-EOR
A Prairie Home Companion  prairie_home
Marketplace marketplaceapm
Marketplace Money radiopiggybank
Marketplace Tech Report MarketplaceTech
On Being  BeingTweets
The Dinner Party  dinnerpartydnld
The Splendid Table  SplendidTable
The Story thestorywithdg
The Writer's Almanac  writersalmanac
Wits  wits
BBC Newshour  BBCNewshour
BBC World Service bbcworldservice
AirTalk Airtalk
Off-Ramp  kpccofframp
Take Two  taketwo
The Loh Down On Science LohDown
The California Report CalReport
All Things Considered npratc
Bullseye  Bullseye
Car Talk  cartalk
Fresh Air nprfreshair
Latino USA  LatinoUSA
Morning Edition MorningEdition
On The Media  onthemedia
Radiolab  radiolab
Science Friday  scifri
Snap Judgment SnapJudgmentOrg
TED Radio Hour  TEDRadioHour
Tell Me More  TellMeMoreNPR
Wait Wait... Don't Tell Me! waitwait
Weekend Edition Saturday  NPRWeekend
Weekend Edition Sunday  NPRWeekend
Ask Me Another  NPRAskMeAnother
The Tavis Smiley Show TavisSmileyShow
The World pritheworld
This American Life  ThisAmerLife
The Moth Radio Hour TheMoth
EOR

    str.split("\n").each do |line|
      line.match(/\A(.+) +(.+)\z/) do |m|
        handle = m[2].strip
        
        if handle.blank?
          $stdout.puts "No handle found in #{m[0]}"
          next
        end

        title  = m[1].strip
        slug   = title.parameterize

        program =
          ExternalProgram.find_by_slug(slug) ||
          ExternalProgram.find_by_title(title) ||
          KpccProgram.find_by_slug(slug) ||
          KpccProgram.find_by_title(title)

        if program
          program.update_column(:twitter_handle, handle)
        else
          $stdout.puts "No program found for #{title} (#{slug})"
        end
      end
    end
  end

  def down
    ExternalProgram.update_all(twitter_handle: nil)
    KpccProgram.update_all(twitter_handle: nil)
  end
end
