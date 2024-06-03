package org.apache.dubbo.samples.client;

import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.common.extension.Activate;
import org.apache.dubbo.rpc.Filter;
import org.apache.dubbo.rpc.Invocation;
import org.apache.dubbo.rpc.Invoker;
import org.apache.dubbo.rpc.Result;
import org.apache.dubbo.rpc.RpcContext;
import org.apache.dubbo.rpc.RpcException;

@Activate(group = CommonConstants.CONSUMER)
public class DemoFilter implements Filter {
    @Override
    public Result invoke(Invoker<?> invoker, Invocation invocation) throws RpcException {
        RpcContext.getClientAttachment().setAttachment("demo", "demo002");
        RpcContext.getServerAttachment().setAttachment("demo", "demo002");
        RpcContext.getServerContext().setAttachment("demo", "demo002");
        RpcContext.getServiceContext().setAttachment("demo", "demo002");
        RpcContext.getContext().setAttachment("demo", "demo002");
        // invocation.setAttachment("demo", "demo002");
        return invoker.invoke(invocation);
    }
}
