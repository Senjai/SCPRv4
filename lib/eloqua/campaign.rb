##
# Eloqua::Campaign
#
module Eloqua
  class Campaign < Entity
    PATH = "assets/campaign"
    
    attr_accessor :type, :currentStatus, :id, :createdAt, :createdBy, :depth, :description,
        :folderId, :name, :updatedAt, :updatedBy, :actualCost, :budgetedCost, :campaignType,
        :isMemberAllowedReEntry, :isReadOnly, :product, :region
        
    def activate
      client = Eloqua::Client.new(API_KEYS['eloqua'])

      client.api.post do |request|
        request.url "assets/campaign/active/#{self.id}"
        request.headers['Content-Type'] = "application/json"
        request.body = ""
      end
    end
  end
end
