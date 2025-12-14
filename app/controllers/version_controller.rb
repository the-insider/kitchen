class VersionController < ApplicationController
  def index
    version_info = {
      rails_env: Rails.env,
      build_version: ENV['BUILD_VERSION'] || 'unknown'
    }

    render json: version_info
  end
end
