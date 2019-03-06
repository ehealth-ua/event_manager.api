# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :event_manager_consumer,
  kaffe_consumer: [
    endpoints: [localhost: 9092],
    topics: ["event_manager_topic"],
    consumer_group: "deactivate_person_events_group",
    message_handler: EventManagerConsumer.Kafka.Consumer
  ]

import_config "#{Mix.env()}.exs"
