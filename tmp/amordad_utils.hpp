/*
 *    Part of AMORDAD software
 *
 *    Copyright (C) 2014 University of Southern California and
 *                       Andrew D. Smith
 *
 *    Authors: Andrew D. Smith
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef AMORDAD_UTILS_HPP
#define AMORDAD_UTILS_HPP

#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <algorithm>

#include "FeatureVector.hpp"

using std::vector;
using std::string;

namespace amordad {
  struct Result {
    Result(const string &i, const double v) : id(i), val(v) {}
    Result() : val(std::numeric_limits<double>::max()) {}
    bool operator<(const Result &other) const {return val < other.val;}
    string id;
    double val;
  };

  std::ostream &
    operator<<(std::ostream &os, const Result &r) {
      return os << r.id << '\t' << r.val;
    }
}


namespace amordad {

  // Return n nearest neighbors from candidates
  void evaluate_candidates(const vector<FeatureVector> &candidates,
                           const FeatureVector &query,
                           const size_t n_neighbors,
                           const double max_proximity_radius,
                           vector<Result> &results); 
}

#endif
