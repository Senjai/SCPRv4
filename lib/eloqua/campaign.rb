##
# Eloqua::Campaign
#
module Eloqua
  class Campaign < Entity
    PATH = "assets/campaign"
    
    attr_accessor :type, :currentStatus, :id, :createdAt, :createdBy, :depth, :description,
        :folderId, :name, :updatedAt, :updatedBy, :actualCost, :budgetedCost, :campaignType,
        :isMemberAllowedReEntry, :isReadOnly, :product, :region, :scheduledFor, :crmId, :elements,
        :endAt, :fieldValues, :startAt, :accessedAt, :permissions, :sourceTemplateId
        
    def activate
      client = Eloqua::Client.new(Rails.application.config.api['eloqua']['auth'])

      client.api.post do |request|
        request.url "assets/campaign/active/#{self.id}"
        request.headers['Content-Type'] = "application/json"
        request.body = ""
      end
    end
  end
end
