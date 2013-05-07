// C&C NLP tools
// Copyright (c) Universities of Edinburgh, Oxford and Sydney
// Copyright (c) James R. Curran
//
// This software is covered by a non-commercial use licence.
// See LICENCE.txt for the full text of the licence.
//
// If LICENCE.txt is not included in this distribution
// please email candc@it.usyd.edu.au to obtain a copy.

#include <cmath>
#include <string>
#include <vector>

#include <iostream>
#include <iomanip>
#include <stdexcept>

using namespace std;

#include "except.h"
#include "utils.h"
#include "utils/io.h"

#include "hash.h"
#include "pool.h"

#include "hashtable/entry.h"

#include "thesaurus/options.h"
#include "thesaurus/type.h"
#include "thesaurus/types.h"
#include "thesaurus/attribute.h"
#include "thesaurus/attributes.h"
#include "thesaurus/weight.h"
#include "thesaurus/relation.h"
#include "thesaurus/object.h"
#include "thesaurus/objects.h"
#include "thesaurus/weights/utils.h"

#include "thesaurus/weights/lin98b.h"

namespace NLP { namespace Thesaurus {

void
WLin98b::init(const Object *o){
  const Relations &rel = o->relations;
  _ftypes.resize(0);

  for(Relations::const_iterator r = rel.begin(); r != rel.end(); ++r){
    ulong id = r->type()->index();
    if(_ftypes.size() <= id)
      _ftypes.resize(id + 1, 0.0);
    _ftypes[id] += f(r);
  }
}

float
WLin98b::operator()(const Object *o, const Attribute *a, const Relation *r) const {
  Type *t = a->type();
  float score = log((f(r)*f(t))/(f(a)*_ftypes[t->index()]));
  return score > 0 ? score : 0;
};

} }
