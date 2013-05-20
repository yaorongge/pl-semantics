mlnFilename=out-dep-varbind/res
gtFilename=results/vid-gt
baseFilename=results/vid-wordgram
pairsimFilename=results/vid-pairsim

#mlnFilename=exp-res-sum-par
#gtFilename=par-gt
#baseFilename=par-wordgram

count=0
cat $mlnFilename | while read act
do
	len=$(expr length "$act")
	len=$(expr $len - 2);
	act=$(expr substr "$act" 2 $len)
	echo $act |sed  's/ /\n/g' > tmp-act

	#Base
	echo "@relation sts" > tmp-train.arff
	echo "@attribute onegram real" >> tmp-train.arff
	echo "@attribute twogram real" >> tmp-train.arff
	echo "@attribute threegram real" >> tmp-train.arff
	echo "@attribute fourgram real" >> tmp-train.arff
	echo "@attribute gt real" >> tmp-train.arff
	echo "@data" >> tmp-train.arff
	paste -d , $baseFilename $gtFilename | head -n 750  >> tmp-train.arff

	echo "@relation sts" > tmp-test.arff
	echo "@attribute onegram real" >> tmp-test.arff
	echo "@attribute twogram real" >> tmp-test.arff
	echo "@attribute threegram real" >> tmp-test.arff
	echo "@attribute fourgram real" >> tmp-test.arff
	echo "@attribute gt real" >> tmp-test.arff
	echo "@data" >> tmp-test.arff
	paste -d , $baseFilename $gtFilename | tail -n 750  >> tmp-test.arff

#	base=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.meta.AdditiveRegression -i -t tmp-train.arff -T tmp-test.arff  -S 0.95 -I 10 -W weka.classifiers.rules.M5Rules -- | grep Correlation | awk '{print $3}' | tr '\n' ' ')
#	echo -n "$base "

	#Base2
	echo "@relation sts" > tmp-train.arff
	echo "@attribute pairsimfull real" >> tmp-train.arff
	echo "@attribute pairsimdiff real" >> tmp-train.arff
	echo "@attribute gt real" >> tmp-train.arff
	echo "@data" >> tmp-train.arff
	paste -d , $pairsimFilename $gtFilename | head -n 750  >> tmp-train.arff

	echo "@relation sts" > tmp-test.arff
	echo "@attribute pairsimfull real" >> tmp-test.arff
	echo "@attribute pairsimdiff real" >> tmp-test.arff
	echo "@attribute gt real" >> tmp-test.arff
	echo "@data" >> tmp-test.arff
	paste -d , $pairsimFilename $gtFilename | tail -n 750  >> tmp-test.arff

#	base2=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.meta.AdditiveRegression -i -t tmp-train.arff -T tmp-test.arff  -S 0.95 -I 10 -W weka.classifiers.rules.M5Rules -- | grep Correlation | awk '{print $3}' | tr '\n' ' ')
#	echo -n "$base2 "

	#MLN
	echo "@relation sts" > tmp-train.arff
	echo "@attribute actMln real" >> tmp-train.arff
	echo "@attribute gt real" >> tmp-train.arff
	echo "@data" >> tmp-train.arff
	paste -d , tmp-act $gtFilename | head -n 750  >> tmp-train.arff

	echo "@relation sts" > tmp-test.arff
	echo "@attribute actMln real" >> tmp-test.arff
	echo "@attribute gt real" >> tmp-test.arff
	echo "@data" >> tmp-test.arff
	paste -d , tmp-act $gtFilename | tail -n 750  >> tmp-test.arff

	mln=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.meta.AdditiveRegression -i -t tmp-train.arff -T tmp-test.arff  -S 0.95 -I 10 -W weka.classifiers.rules.M5Rules -- | grep Correlation | awk '{print $3}' | tr '\n' ' ')
	#mln=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.functions.LinearRegression -i -t tmp-train.arff -T tmp-test.arff | grep Correlation | awk '{print $3}' | tr '\n' ' ')
	echo -n "$mln "
	
#Combined
	echo "@relation sts" > tmp-train.arff
	echo "@attribute onegram real" >> tmp-train.arff
	echo "@attribute twogram real" >> tmp-train.arff
	echo "@attribute threegram real" >> tmp-train.arff
	echo "@attribute fourgram real" >> tmp-train.arff
	echo "@attribute actMln real" >> tmp-train.arff
	#echo "@attribute pairsimfull real" >> tmp-train.arff
	#echo "@attribute pairsimdiff real" >> tmp-train.arff
	echo "@attribute gt real" >> tmp-train.arff
	echo "@data" >> tmp-train.arff
   paste -d , $baseFilename tmp-act  $gtFilename | head -n 750  >> tmp-train.arff
	#paste -d , $baseFilename tmp-act $pairsimFilename $gtFilename | head -n 750  >> tmp-train.arff

	echo "@relation sts" > tmp-test.arff
	echo "@attribute onegram real" >> tmp-test.arff
	echo "@attribute twogram real" >> tmp-test.arff
	echo "@attribute threegram real" >> tmp-test.arff
	echo "@attribute fourgram real" >> tmp-test.arff
	echo "@attribute actMln real" >> tmp-test.arff
	#echo "@attribute pairsimfull real" >> tmp-test.arff
	#echo "@attribute pairsimdiff real" >> tmp-test.arff

	echo "@attribute gt real" >> tmp-test.arff
	echo "@data" >> tmp-test.arff
	#paste -d , $baseFilename tmp-act $pairsimFilename $gtFilename | tail -n 750  >> tmp-test.arff
   paste -d , $baseFilename tmp-act  $gtFilename | tail -n 750  >> tmp-test.arff


#	comb=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.meta.AdditiveRegression -i -t tmp-train.arff -T tmp-test.arff  -S 0.95 -I 10 -W weka.classifiers.rules.M5Rules -- | grep Correlation | awk '{print $3}' | tr '\n' ' ')
	#comb=$(java -Xmx1024m -cp ../../weka/weka.jar weka.classifiers.functions.LinearRegression -i -t tmp-train.arff -T tmp-test.arff | grep Correlation | awk '{print $3}' | tr '\n' ' ')

	echo $comb
	#exit
done
