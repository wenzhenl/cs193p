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

#include "amordad_utils.hpp"

using std::vector;
using amordad::Result;

// Return n nearest neighbors from candidates
void evaluate_candidates(const vector<FeatureVector> &candidates,
    const FeatureVector &query,
    const size_t n_neighbors,
    const double max_proximity_radius,
    vector<Result> &results) {

  std::priority_queue<Result, vector<Result>, std::less<Result> > pq;
  double current_dist_cutoff = max_proximity_radius;
  for (vector<FeatureVector>::const_iterator i(candidates.begin());
      i != candidates.end(); ++i) {
    const double dist = query.compute_angle(*i);
    if (dist < current_dist_cutoff) {
      if (pq.size() == n_neighbors)
        pq.pop();
      pq.push(Result(i->get_id(), dist));

      if(pq.size() == n_neighbors)
        current_dist_cutoff = pq.top().val;
    }
  }

  results.clear();
  while (!pq.empty()) {
    results.push_back(pq.top());
    pq.pop();
  }
  reverse(results.begin(), results.end());
}
