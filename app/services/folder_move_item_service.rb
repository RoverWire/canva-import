class FolderMoveItemService < ApplicationService
  attr_reader :canva_folder_id
  attr_reader :canva_folder_name
  attr_reader :check_all

  def initialize(batch_size = 80, check_all = false)
    super
    @batch_size = batch_size
    @canva_folder_id = ENV.fetch('CANVA_FOLDER_ID')
    @canva_folder_name = ENV.fetch('CANVA_FOLDER_NAME')
    @check_all = check_all
  end

  def call
    canva_folder = Canva::Folder.new
    Template.where(condition_array).limit(80).each do |template|
      response = canva_folder.move_item(template.canva_design_id, canva_folder_id)

      if response.code == '204'
        params = { import_status: 'completed', export_status: 'waiting', canva_folder_name:, canva_folder_id: }
        template.update!(params)
      end
    end
  end

  private

  def condition_array
    return ["import_status = ?", 'success'] if check_all

    ["import_status = ? AND import_device = ?", 'success', import_device]
  end
end
