module GoogleDriveAdapter
  module_function

  ROOT_PARENT_ID = '1ucIa7E9E3eG7ldf5ckqKZoVXTHf0qZcq'.freeze

  def client
    # TODO: las credenciales hay que guardarlas en otro lado
    # doc: https://www.rubydoc.info/gems/google_drive/3.0.7/GoogleDrive/Session
    @client ||= GoogleDrive::Session.from_config("lib/config.json")
  end

  def create_file(title, parent_id = ROOT_PARENT_ID)
    client.create_file(title, parents: [parent_id])
  end

  def create_folder(title, parent_id = ROOT_PARENT_ID)
    client.create_collection(title, parents: [parent_id])
  end
end
