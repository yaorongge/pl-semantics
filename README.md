mln-semantics
=============

Set up workspace (without PSL)
----------------

    ~$ git clone git@github.com:islambeltagy/mln-semantics.git
    ~/mln-semantics$ cd mln-semantics

    ~/mln-semantics$ cd lib
    ~/mln-semantics/lib$ ln -s /u/beltagy/workspace/deft/mln-semantics/lib/ws4j-1.0.1.jar ws4j-1.0.1.jar
    ~/mln-semantics/lib$ cd ..

    ~/mln-semantics$ bin/mlnsem compile
    
    ~/mln-semantics$ cd alchemy/src
    ~/mln-semantics/alchemy/src$ make
    ~/mln-semantics/lib$ cd ../..

    ~/mln-semantics$ cd candc
    ~/mln-semantics/candc$ ln -s /u/beltagy/workspace/deft/mln-semantics/candc/models models
    ~/mln-semantics/candc$ make
    ~/mln-semantics/candc$ cd ..
    
    ~/mln-semantics$ cd resources
    ~/mln-semantics/resources$ ln -s /u/dhg/Corpora/nytgiga.lem.vc.f2000.m50.wInf.txt full.vs
    ~/mln-semantics/resources$ ln -s /u/dhg/Corpora/wordnet-3.0/ wordnet
    ~/mln-semantics/resources$ ln -s /u/beltagy/workspace/deft/mln-semantics/resources/englishPCFG.ser.gz englishPCFG.ser.gz
    ~/mln-semantics/resources$ ln -s /u/beltagy/workspace/deft/mln-semantics/resources/rules rules
    ~/mln-semantics/resources$ ln -s /u/beltagy/workspace/deft/mln-semantics/resources/phrase-vectors phrase-vectors
    ~/mln-semantics/resources$ cd ..
    
    ~/mln-semantics$ bin/mlnsem gen prb		#Generate helping files for a toy dataset I call it prb
    ~/mln-semantics$ bin/mlnsem run prb		#Run the toy examples of prb


Running our system on different datasets
----------------------
- RTE and STS datasets we have now are FraCas, RTE1, RTE2, RTE3, MsrVid, MsrPar, Prob
I will add RTE4-RTE7 and Trento dataset soon. Each dataset has an apprevition (listed in bin/mlnsem)

	* FraCas: frc
	* MsrVid: vid
	* MsrPar: par
	* RTEi: rte i 
	* SICK as an RTE task: sick-rte
	* SICK as an STS task: sick-sts
	* Prob: prb		#This dataset contains few examples I selected. Each example represents one specific Problem. 

- First, some helping files need to be generated for each dataset using:

	~/mln-semantics$ bin/mlnsem gen DataSetAppreviation

For example:

	~/mln-semantics$ bin/mlnsem gen rte 2

- Then, run the system for this dataset: 

	~/mln-semantics$ bin/mlnsem run DataSetAppreviation

- Please check bin/mlnsem for more details

Command line arguments
----------------------
They are all listed in 

src/main/scala/utcompling/mlnsemantics/util/Config.scala

Default values are good enough to run the system. Only one argument is not listed, which is the "range" argument. 

Let's say you want to run the 4th, 5th, 6th, and 9th pairs of FraCas. Command is: 

	~/mln-semantics$ bin/mlnsem run frc 4-6,9

Import the project into Eclipse: 
--------------------

- Install Scala's plugin on your eclipse.

- Use sbt to generate eclipse project files: 

* java -jar bin/sbt-launch*.jar

* When it starts, type: `eclipse`

* Two projects are generated mln-semantics and scala-logic. Import them to eclipse and you are done. 

Running on Condor
-----------------
Entry point for running the system on Condor is the script

	~/mln-semantics$ bin/condor.sh

The script provides the following functionalities: 

* Get status of Condor jobs

   ~/mln-semantics$ bin/condor.sh  status

*  Remove all submitted Condor jobs

	~/mln-semantics$ bin/condor.sh  remove

* Submit new jobs to Condor. EXP_NAME: is the name of the experiment, output from condor will be stored in condor/EXP_NAME/ . STEP is number of pairs per job. ARGS are the usual arguments you want to pass to bin/mlnsem (execluding the leading "run" and the range argument). Output files are saved in mln-semantics/condor/EXP_NAME/. Be careful, consecutive submissions of tasks with the same EXP_NAME  will overwrite each others. The file: mln-semantics/condor/EXP_NAME/config contains the command line arguments passed to the condor script. 

	~/mln-semantics$ bin/condor.sh submit EXP_NAME STEP ARGS 

for example: submit the sick dataset to condor. Output from condor will be saved in condor/firstExp.  Each Condor job contains 10 pairs of sentences. Run each pair for 30 seconds, and do not print any log

	~/mln-semantics$ bin/condor.sh submit firstExp 10 sick-rte -timeout 30000 -log OFF 

* Prints a list of the tasks without submitting anything. This is helpful to check the number of tasks and arguments before submitting the tasks.

	~/mln-semantics$ bin/condor.sh print EXP_NAME STEP ARGS

* In some cases (for reasons I do not understand) some condor tasks break without notice. Calling the condor script with the argument "fix" checks all output files and make sure that all condor tasks terminated correctly. If some of them did not, resubmit them again. Make sure to use the same STEP and ARGS. Do not call "fix" while some taks are already running . Make sure to use the same STEP that was used during "submit"

   ~/mln-semantics$ bin/condor.sh fix EXP_NAME STEP ARGS 

* Collects results of individual tasks into one block and prints it. Make sure to use the same STEP.  

   ~/mln-semantics$ bin/condor.sh collect EXP_NAME STEP 

Classification and Regression
-----------------------------

We use WEKA for classification and Regression. We use AdaBoost for classification for RTE, and Additive Regression for regression for STS. 
The script bin/weka.sh is to make this task easy. 

The script bin/weka.sh can be called like this: 

   ~/mln-semantics$ cat ACTUAL | bin/weka.sh COMMAND GoldStandardFile NumberOfColumns

where

* ACTUAL: is a file contains the system's output score in one long line. 

* COMMAND: "classify" or "regress" depending on the task

* GoldStandardFile: the name is descriptive enough. A sample file is resources/sick/sick-rte.gs

* NumberOfColumns[optional, defaul = 1]: number of columns in ACTUAL. It is useful in case of STS which outputs two columns, and in multiple parses which outout squared numbers of parses. This argument is optional, and its default value is 1. 

Example: after running the system on Condor, you can read the output using the condor script with argument "collect" as shown before. One easy way to get the classification/regression score is by piping the output from the condor scrip to the weka script as below: 

	~/mln-semantics$ bin/condor.sh collect firstExp 10 | tail -n 1  | bin/weka.sh regress resources/sick/sick-rte.gs  1 


Using Boxer
-----------

    ~/mln-semantics$ bin/mlnsem boxer OPTIONS

You can parse a single sentence with the `-s` option:

    ~/mln-semantics$ bin/mlnsem boxer -s "A dog walks." [OPTIONS]

or an entire file of sentences (one sentence per line):

    ~/mln-semantics$ bin/mlnsem boxer -f sentences.txt [OPTIONS]

Output options:

    -draw true/false (default: true)        Prints a graphical DRT representation
    -boxer true/false (default: true)       Prints logical form in Boxer notation
    -drt true/false (default: true)         Prints the logical form as a DRS
    -fol true/false (default: true)         Prints the logical form in first-order logic
    
Regarding tokenization: The code will automatically tokenize all input sentences, so it does not matter if
the input is given tokenized or not.  It will not do sentence-splitting, however, but this can be included
if it would be useful.


Run Aidan's code on local machine (NOT PART OF THE SYSTEM YET)
---------------------------------
* git clone git@github.com:raptros/tr-corpus-one.git

* Start the soap server with the correct arguments - `$CANDC_HOME/bin/soap_server --models $CANDC_HOME/models --server localhost:12200 --candc-printer boxer` will do the job

* ./run local trc1.MaxTransform data/rules.in data/sentences.txt data/out


RTE changed done by Cuong (Obsolete. I changed the code significantly afterwards)
---------------------------

* Experimented with prior -1.0

* In Sts.scala:

Employ Lucene for indexing and searching inference rules from external resources.
See `/utcompling/mlnsemantics/util/Lucene.scala` for more details.
Each rule has the following format:
<id> TAB <lhs> TAB <rhs> TAB <entail_score> 

Put type constraints for variables via `FindEventsProbabilisticTheoremProver` class.

* In AlchemyTheoremProver.scala:

Function `createSamePredRule` generates inference rules for each pair of predicates having the same name.
E.g., man_dt(indv0) => man_dh(indv0).
This function also employs WordNet to find similar words.

Function `makeEvidenceFile` removes all evidence predicates that don't appear in inference rules.
This can help to reduce domain size.

Function `makeMlnFile` removes all theme relation predicates and equality constraints in Hypothesis 
because there are no inference rules for them. 
To do that easier, I remove inner parentheses of conjunction expressions (see funtion `_convert`).

* In InferenceRuleInjectingProbabilisticTheoremProver.scala:

Function `checkCompatibleType` checks compatibility between lhs and rhs of an inference rule.

Function `convertParaphraseToFOL` converts paraphrase rules in text format to FOL.

Function `getAllRelations` also gets "agent" and "patient" relations.

* In MergeSameVarPredProbabilisticTheoremProver.scala:

Function `getAllPreds` puts entity type for BoxerNamed.

Do not merge same variable predicates.

* In HardAssumptionAsEvidenceProbabilisticTheoremProver.scala:

Change `renameVars`.

* Remove ("--candc-int-betas" -> "0.00075 0.0003 0.0001 0.00005 0.00001") parameter from 
`/utcompling/mlnsemantics/datagen/CncLemmatizeCorpus.scala` and `/utcompling/scalalogic/discourse/impl/BoxerDiscourseInterpreter.scala`
because we get more parse fails with it.

* In utcompling/scalalogic/discourse/candc/boxer/expression/interpreter/impl/OccurrenceMarkingBoxerExpressionInterpreterDecorator.scala:

Get positions of words in sentence. Words with same name will be treated differently based on their position.


Trento errors (Cuong's notes)
-------------

* Parser errors: 
 - Wrong POS tags. Several verbs are classified as nouns.
 - Wrong semantic representations.

* Problem with negation.

* Problem with directional distributional similarity.

* Problem with singular and plural nouns.

* No vector representation for sentences "A woman fries eggs" and "A woman fries big eggs" in group 5.



