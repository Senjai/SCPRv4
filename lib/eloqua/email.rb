##
# Eloqua::Email
#
module Eloqua
  class Email < Entity
    PATH = "assets/email"

    attr_accessor :type, :currentStatus, :id, :createdAt, :createdBy, :depth, :folderId, :name,
      :permissions, :updatedAt, :updatedBy, :bounceBackEmail, :emailGroupId, :htmlContent,
      :isPlainTextEditable, :isTracked, :plainText, :replyToEmail, :replyToName, :sendPlainTextOnly,
      :sendEmail, :senderName, :style, :subject
  end
end
