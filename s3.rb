require 'aws-sdk'

# Usage: 
# add to ruhoh-site/plugins/publish/s3.rb
# @param[opts] - CLI arguments
# @param[config] - config hash supplied from publish.yml or publish.json
#
# Example publish.json file:
# {
#	"s3": {
#		"bucket": "www.example.com"
#	}
# }
#
# $ cd ruhoh-site
# $ bundle exec ruhoh publish s3

class Ruhoh
	class Publish::S3		
		def run(opts={}, config={})
			check_for_config(config)

			ruhoh = compile	

			bucket_name = config["bucket"] if config.has_key?("bucket")

			s3 = create_s3_client

			clear_bucket_contents(s3, bucket_name)

			upload_to_s3(s3, bucket_name, ruhoh.config['compiled_path'])

			clean_up_files(ruhoh.config['compiled_path'])
		end

		def check_for_config(config)
			if config.nil?
				puts "No publish.(json/yml) config file found. Exiting..."
				exit
			end
		end
		
		def compile
			ruhoh = Ruhoh.new
			ruhoh.env = 'production'
			ruhoh.setup_plugins

			config_overrides = set_configuration(ruhoh.config)
			ruhoh.config.merge!(config_overrides)

			ruhoh.config['compiled_path'] = File.join(Dir.tmpdir, 'compiled')
			ruhoh.compile
			ruhoh
		end

		def set_configuration(config)
			opts = {}
			opts['compile_as_root'] = true
			opts['base_path'] = "/"

			opts
		end
		
		def create_s3_client
			Aws::S3::Client.new(
				region: ENV['AWS_REGION'], 
				access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
				secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']) 
		end

		def clear_bucket_contents(s3, bucket_name)
			s3r = Aws::S3::Resource.new(s3)

			puts "Clearing bucket #{ bucket_name }."
			s3r.bucket(bucket_name).clear!
		end		

		def upload_to_s3(s3, bucket_name, upload_dir)
			Dir.glob("#{ upload_dir }/**/*") do |item|
				next unless item[/\..+$/]
				
				name = item[/^#{ upload_dir }\/(.+)/, 1]
				data = File.read(item)
				
				s3.put_object(
					bucket: bucket_name,
					key: name,
					body: data)
				
				puts "Uploading files #{ name } to bucket #{ bucket_name }"
			end
		end

		def clean_up_files(path)
			puts "Deleting directory #{ path }."
			FileUtils.rm_rf(path)
		end
	end
end
