##
# SpecialsController
# 
# Throw temporary stuff in here, such as Elections results pages
# Any action in here shouldn't last more than a month or so, before
# being turned into a flatpage.
#
# Thing of these as "Flatpages Plus"
#
class SpecialsController < ApplicationController
  def march2013elections
    @flatpage    = Flatpage.where(id: 360).first # Mayor flatpage
    @data_points = DataPoint.where(group_name: "election-march2013").order('id asc')
  end
end
