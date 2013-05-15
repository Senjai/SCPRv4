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
  def elections
    # May Elections
    @data_points    = DataPoint.to_hash(DataPoint.where(group_name: "election-may2013").order('id asc'))
    @cache_control  = DataPoint.to_hash(DataPoint.where(group_name: "cache-control"))
    @flatpage       = Flatpage.where(id: 360).first # Mayor flatpage
  end
end
