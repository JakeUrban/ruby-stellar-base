module Stellar
  Transaction.class_eval do

    def self.payment(attributes={})
      destination = attributes[:destination]
      amount      = attributes[:amount]

      raise ArgumentError unless destination.is_a?(KeyPair)

      for_account(attributes).tap do |result|
        payment = PaymentTx.send(*amount)
        payment.destination = destination.public_key
        payment.apply_defaults

        result.body = payment.to_tx_body
      end
    end

    def self.change_trust(attributes={})
      line  = Currency.send(*attributes[:line])
      limit = attributes[:limit]

      raise ArgumentError, "Bad :limit #{limit}" unless limit.is_a?(Integer)

      for_account(attributes).tap do |result|
        details = ChangeTrustTx.new(line: line, limit: limit)

        result.body = details.to_tx_body
      end
    end

    def self.for_account(attributes={})
      account       = attributes[:account]
      sequence      = attributes[:sequence]
      sequence_slot = attributes[:sequence_slot]
      
      raise ArgumentError, "Bad :account" unless account.is_a?(KeyPair) && account.sign?
      raise ArgumentError, "Bad :sequence #{sequence}" unless sequence.is_a?(Integer)

      unless sequence_slot.nil? || sequence_slot.is_a?(Integer)
        raise ArgumentError, "Bad :sequence_slot #{sequence_slot}"
      end 

      new.tap do |result|
        result.seq_slot = sequence_slot
        result.seq_num  = sequence
        result.account  = account.public_key
        result.apply_defaults
      end
    end

    def sign(key_pair)
      key_pair.sign(hash)
    end

    def hash
      Digest::SHA256.digest(to_xdr)
    end

    def to_envelope(*key_pairs)
      signatures = key_pairs.map(&method(:sign))
      
      TransactionEnvelope.new({
        :signatures => signatures,
        :tx => self
      })
    end

    def apply_defaults
      self.seq_slot   ||= 0
      self.max_fee    ||= 10
      self.min_ledger ||= 0

      # NOTE: the effective limit of max_ledger is (2^63 - 1), since while
      # the XDR for is an unsigned 64-bit integer, the sql systems that store
      # the transaction data do not support unsigned 64-bit integers. 
      self.max_ledger ||= 2**63 - 1
    end
  end
end