//
//  operations-and-indexing.h
//  swix
//
//  Created by Vasiliy Dumanov on 2/28/19.
//  Copyright © 2019 com.scott. All rights reserved.
//

#ifndef operations_and_indexing_h
#define operations_and_indexing_h

void index_xa_b_objc(double * x, double*a, double*b, int N);
void svd_objc(double * xx, int m, int n, double* sigma, double* vt, double* u, int compute_uv);
void test();

#endif /* operations_and_indexing_h */
