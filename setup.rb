system 'find ./positive_images -iname "*.jpg" > positives.txt'
puts "merge positives"
system 'find ./negative_images -iname "*.jpg" > negatives.txt'
puts "merge negatives"

# system 'opencv_createsamples -info positives.txt -num 10 -bg negatives.txt -vec samples/' + line + '.vec -maxxangle 0.16 -maxyangle 0.16 -maxzangle 0.02 -w 100 -h 100 -bgcolor 0'

File.open('positives.txt','r').read.each_line{|line|
  line = line.chomp
  line = line.split("/").last
  system 'opencv_createsamples -img positive_images/' + line + '  -num 10 -bg negatives.txt -vec samples/' + line + '.vec -maxxangle 0.16 -maxyangle 0.16 -maxzangle 0.02 -w 100 -h 100 -bgcolor 0'
}
puts "create vecs"
system 'python mergevec.py -v samples -o samples.vec'
puts "merge vecs"



=begin
opencv_traincascade -data classifier -vec samples.vec -bg negatives.txt -numStages 20 -minHitRate 0.999 -maxFalseAlarmRate 0.5 -numPos 200 -numNeg 100 -w 100 -h 100 -mode ALL -precalcValBufSize 7000 -precalcIdxBufSize 7000 -featureType LBP

=end
