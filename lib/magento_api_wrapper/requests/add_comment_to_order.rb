module MagentoApiWrapper::Requests
  class AddCommentToOrder

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      order_comment_request_hash
    end

    def order_comment_request_hash
      {
          session_id: self.session_id,
          order_increment_id: self.order_increment_id,
          status: self.status,
          comment: self.comment
      }
    end

    def session_id
      data[:session_id]
    end

    def order_increment_id
      data[:order_increment_id]
    end

    def status
      data[:status]
    end

    def comment
      data[:comment]
    end

  end
end
