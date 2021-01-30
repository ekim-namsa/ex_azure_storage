defmodule AzureStorage.Table do
  @moduledoc """
  Azure Table Service
  ref. https://docs.microsoft.com/en-us/rest/api/storageservices/table-service-rest-api
  """
  alias AzureStorage.Table.EntityDescriptor
  alias AzureStorage.Core.Account
  alias AzureStorage.Request

  @storage_service "table"

  def retrieve_entity(%Account{} = account, table_name, partition_key, row_key) do
    query =
      "#{table_name}(PartitionKey='#{partition_key}',RowKey='#{row_key}')"
      |> String.replace("'", "%27")

    account
    |> Request.get(@storage_service, query)
  end

  @doc """
  Deletes an existing entity in a table.
  """
  def delete_entity(%Account{} = account, table_name, partition_key, row_key, etag \\ "*") do
    query =
      "#{table_name}(PartitionKey='#{partition_key}',RowKey='#{row_key}')"
      |> String.replace("'", "%27")

    options = [
      {:"if-match", etag}
    ]

    account
    |> Request.delete(@storage_service, query, options)
  end

  @doc """
  ref. https://docs.microsoft.com/en-us/rest/api/storageservices/insert-entity
  """
  def insert_entity(%Account{} = account, table_name, %EntityDescriptor{} = entity_descriptor) do
    query = "#{table_name}"
    body = entity_descriptor |> Jason.encode!()

    options = [
      {:Prefer, "return-no-content"},
      {:"Content-Type", "application/json"}
    ]

    account |> Request.post(@storage_service, query, body, options)
  end
end