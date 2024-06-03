/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.dubbo.samples.basic.filter;

import com.alibaba.dubbo.common.extension.Activate;
import com.alibaba.dubbo.rpc.Filter;
import com.alibaba.dubbo.rpc.Invocation;
import com.alibaba.dubbo.rpc.Invoker;
import com.alibaba.dubbo.rpc.Result;
import com.alibaba.dubbo.rpc.RpcException;
import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.rpc.RpcContext;
import org.apache.dubbo.samples.basic.api.User;

@Activate(group = CommonConstants.CONSUMER)
public class DemoFilter implements Filter {
    @Override
    public Result invoke(Invoker<?> invoker, Invocation invocation) throws RpcException {
        System.out.println("RpcContext.getServiceContext() = " + RpcContext.getClientAttachment());
        RpcContext.getClientAttachment().setAttachment("demo", "demo002");
        RpcContext.getContext().setAttachment("demo","demo02");
//        RpcContext.getContext().setAttachment("demo", "demo002");

        invocation.setAttachment("demo","demo2");
        System.out.println("进去调用");
        System.out.println("RpcContext.getServiceContext().getAttachment(\"demo\") = " + RpcContext.getClientAttachment().getAttachment("demo"));
        Result result = invoker.invoke(invocation);
        return result;
    }
}
