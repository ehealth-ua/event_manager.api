use Mix.Config

config :event_manager_consumer,
  kaffe_consumer: [
    endpoints: {:system, :string, "KAFKA_BROKERS"},
    topics: ["event_manager_topic"],
    consumer_group: "event_topic_group",
    message_handler: EventManagerConsumer.Kafka.Consumer
  ]
