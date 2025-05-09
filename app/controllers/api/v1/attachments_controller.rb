module Api
  module V1
    class AttachmentsController < ApplicationController
      # Omitir verificación CSRF para API
      skip_before_action :verify_authenticity_token
      before_action :set_issue
      require 'aws-sdk-s3'

      # GET /api/v1/issues/:issue_id/attachments
      def index
        attachments_with_urls = @issue.attachments.map do |attachment|
          # Obtener URL directa de S3
          s3_direct_url = get_s3_direct_url(attachment)

          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            content_type: attachment.content_type,
            created_at: attachment.created_at,
            url_directa: s3_direct_url || url_for(attachment) # Usar URL de redirección como fallback
          }
        end

        render json: attachments_with_urls
      end

      # POST /api/v1/issues/:issue_id/attachments
      def create
        if params[:attachment].present?
          @issue.attachments.attach(params[:attachment])
          attachment = @issue.attachments.last

          # Obtener URL directa de S3
          s3_direct_url = get_s3_direct_url(attachment)

          render json: {
            id: attachment.id,
            filename: attachment.filename.to_s,
            content_type: attachment.content_type,
            created_at: attachment.created_at,
            url: s3_direct_url || url_for(attachment) # Usar URL de redirección como fallback
          }, status: :created
        else
          render json: { error: "No attachment provided" }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issues/:issue_id/attachments/:id
      def destroy
        attachment = ActiveStorage::Attachment.find_by(id: params[:id])

        if attachment.nil?
          render json: { error: "Attachment not found" }, status: :not_found
        elsif attachment.record_id != @issue.id
          render json: { error: "Attachment does not belong to this issue" }, status: :forbidden
        else
          attachment.purge
          head :no_content
        end
      end

      private

      def set_issue
        @issue = Issue.find(params[:issue_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Issue not found" }, status: :not_found
      end

      # Obtener URL directa de S3 para un attachment
      def get_s3_direct_url(attachment)
        begin
          # Verificar que el attachment esté almacenado en S3
          return nil unless attachment.service.is_a?(ActiveStorage::Service::S3Service)

          # Obtener la clave del objeto en S3
          key = attachment.key

          # Configurar el cliente S3
          s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'] || 'us-east-1')

          # Obtener el bucket
          bucket_name = ENV['AWS_BUCKET'] || Rails.application.config.active_storage.service_configurations[:amazon][:bucket]
          bucket = s3.bucket(bucket_name)

          # Obtener el objeto
          object = bucket.object(key)

          # Generar URL presignada con expiración de 1 hora
          object.presigned_url(:get, expires_in: 3600)
        rescue => e
          # Si hay algún error, registrarlo y devolver nil para usar el fallback
          Rails.logger.error("Error al obtener URL directa de S3: #{e.message}")
          nil
        end
      end
    end
  end
end
