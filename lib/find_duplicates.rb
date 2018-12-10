require "rubygems/text"

require 'csv'

class FindDuplicates
attr_accessor :nonDuplicateArray, :duplicateArray, :count

def initialize(duplicateArray = [], count=0, nonDuplicateArray = [])
	@nonDuplicateArray = nonDuplicateArray
	@duplicateArray = duplicateArray
	@count = count
end

def readCSV(filepath)
	puts "in readCSV method...."
	people = CSV.read(filepath)
	prev_rec = []
	@duplicateArray.push(people[0])
	# remove the header row from the array.
	people = people.drop(1)
	# sort the array on firstname.
	people = people.sort_by { |a| a[1] }
	people.each do |p|
		# check if lastname and email id's are same
	if prev_rec != [] && (p[4].to_s == prev_rec[4].to_s && p[2].to_s == prev_rec[2].to_s || p[11].to_s == prev_rec[11].to_s && p[2].to_s == prev_rec[2].to_s )then
		@count = @count + 1
		puts "there is duplicate need to check"
		origRec = compareDuplicates(prev_rec, p)
		if(origRec == "prev")
			@duplicateArray.push(p)
			
		else
			# remove the prev record from nonduplicate list and push into duplicate list
			if(prev_rec = @nonDuplicateArray.last)
			@duplicateArray.push(@nonDuplicateArray.pop)
			end
			@nonDuplicateArray.push(p)
		end

	else
		@nonDuplicateArray.push(p)
 	end
 		prev_rec = p
	end


end

def compareDuplicates(prev_rec, next_rec)
	ld = Class.new.extend(Gem::Text).method(:levenshtein_distance)
	puts "previous record " + prev_rec[4]
	puts "next_rec  " + next_rec[4]
	# if the records are completely duplicate
	if(ld.call(prev_rec[1].to_s, next_rec[1].to_s) == 0 && ld.call(prev_rec[3].to_s, next_rec[3].to_s) == 0 && ld.call(prev_rec[5].to_s, next_rec[5].to_s) == 0)
		#check if address2 is nill
		return next_rec[6].to_s == '' ? "prev" : "next"
	end
	# check if first names are same
	if(ld.call(prev_rec[1].to_s, next_rec[1].to_s) == 0)

		# check for company
		if(ld.call(prev_rec[3].to_s, next_rec[3].to_s) > 0 )
			# fix the company name
			return next_rec[5].to_s == '' ? "prev" : (prev_rec[3].to_s.length > next_rec[3].to_s.length ? "prev" : "next")
		end
	else
		# if only firstname different and remaining same
		if(ld.call(prev_rec[3].to_s, next_rec[3].to_s) == 0 && ld.call(prev_rec[5].to_s, next_rec[5].to_s) == 0)
			return prev_rec[1].to_s.length > next_rec[1].to_s.length ? "prev" : "next"
		end

	end

end

def printDuplicates
	@duplicateArray.each do |p|
	# puts p[0] + " , " + p[1] + " , " + p[2] + " , " + p[3] + " , " + p[4] + " , " + p[5] + " , " + p[6] + " , " + p[7] + " , " + p[8] + " , " + p[9] + " , " + p[10] + " , " + p[11]
	puts [p[0] , p[1] ,p[2] , p[3] , p[4] , p[5]  , p[6] , p[7] , p[8] , p[9] , p[10] , p[11]].map(&:to_s).join(', ')
	end
end

def printNonDuplicates
	@nonDuplicateArray.each do |p|
	puts [p[0] , p[1] ,p[2] , p[3] , p[4] , p[5]  , p[6] , p[7] , p[8] , p[9] , p[10] , p[11]].map(&:to_s).join(', ')
	end
end

end


