class CampaignFinisherWorker < ProjectBaseWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform id
    resource(id).payments.each do |payment|
      payment.pagarme_delegator.update_transaction
      payment.change_status_from_transaction
    end

    resource(id).finish
  end
end
