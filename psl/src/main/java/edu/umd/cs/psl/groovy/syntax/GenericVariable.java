/*
 * This file is part of the PSL software.
 * Copyright 2011 University of Maryland
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package edu.umd.cs.psl.groovy.syntax;

import edu.umd.cs.psl.model.argument.Variable;
import edu.umd.cs.psl.model.argument.type.ArgumentType;
import edu.umd.cs.psl.model.argument.type.ArgumentTypes;
import edu.umd.cs.psl.model.set.term.VariableSetTerm;
import edu.umd.cs.psl.groovy.PSLModel;
import edu.umd.cs.psl.model.atom.Atom;
import edu.umd.cs.psl.model.atom.TemplateAtom;
import edu.umd.cs.psl.model.predicate.SpecialPredicates;

public class GenericVariable {
	
	private final String name;
	private final PSLModel model;
	
	public GenericVariable(String s, PSLModel m) {
		name =s;
		model = m;
	}
	
	public String toString() {
		return name;
	}
	
	public String getName() {
		return name;
	}
	
	public Variable toAtomVariable() {
		return new Variable(name);
	}
	
	SetFormulaConstructor propertyMissing(String name) {
		return new SetFormulaConstructor(model,name,this,OIPModifier.None);
	}
	
	/*def methodMissing(String name, args) {
		if (args.length==0) return new SetFormulaConstructor(model,name,this,OIPModifier.None);
		else if (args.length==1) return new SetFormulaConstructor(model,name,this,OIPModifier.parse(args[0]));
		else throw new IllegalArgumentException("Unrecognized modifier used on predicate [${name}] in set term construction: ${args}");
	}*/
	
	FormulaContainer xor(GenericVariable other) {
		if (!(other instanceof GenericVariable)) {
			throw new IllegalArgumentException("Can only compare variables to variables! ${this} compared to ${other}");
		}
		assert other instanceof GenericVariable;
		return new FormulaContainer(new TemplateAtom(SpecialPredicates.NonSymmetric, new Variable[]{this.toAtomVariable(),other.toAtomVariable()}));
	}
	
	
	VariableSetTerm getSetTerm() {
		return new VariableSetTerm(new Variable(name), ArgumentTypes.Entity);
	}

	
}