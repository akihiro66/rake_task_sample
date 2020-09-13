#CSVファイルを扱う為に必要
require 'csv'

#名前空間 => import
namespace :import_csv do
#タスクの説明
  desc "CSVデータをインポートするタスク"
  
  #タスク名 => users
  task users: :environment do
    #インポートするファイルのパスを取得
    path = File.join Rails.root, "db/csv_data/csv_data.csv"
    #インポートするデータを格納する為の配列
    list = []
    #CSVファイルからインポートするデータを取得し配列に格納
    CSV.foreach(path, headers: true) do |row|
      list << {
        name: row["name"],
        age: row["age"],
        address: row["address"]
      }
    end
    puts "インポート処理を開始".red
    
    begin
      User.transaction do
        User.create!(list)
      end
      
      puts "インポート完了！！".green
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "インポートに失敗:UnknownAttributeError".red
    end
  end
end
