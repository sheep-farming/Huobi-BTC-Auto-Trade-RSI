in=23;
interval=2.5;
sellRate=0.0005; % .5%
stopLossRate=0.0007;
stockPrice=0;
BTCCNY=0;
money=100;
coin=0;
Stock=0; % 1:BTC in
sj=[100];
totalValue=100;

%BTC=FetchHuobiData();

try
    BTC;
catch
    BTC=[];
end
clc;
for i=(1:20)
try
    
    data=eval(strrep((strrep(webread('http://greedyfz.sinaapp.com/'),'"','''')),':',','));
    last=data{4}(4);
    BTC(length(BTC)+1).close=last{1};
    BTC(length(BTC)).time=now;
    fprintf('.');

catch
end
pause(interval)
end
clc;


while(1==1)

try
    data=eval(strrep((strrep(webread('http://greedyfz.sinaapp.com/'),'"','''')),':',','));
    last=data{4}(4);
    BTC(length(BTC)+1).close=last{1};
    BTC(length(BTC)).time=now;
    
catch
end
    clf;
    %ret=price2ret([BTC.close],[BTC.time]);
    BTCCNY=[BTC(length(BTC)).close];
    %ret=ret';
    %mean(ret);

    %close
    plot([BTC.time],[BTC.close],'k');
    hold on
    rsi = rsindex([BTC.close]', 14);


    
    for i=(1:length(BTC))
        if(rsi(i)>=100-in)
            plot(BTC(i).time,BTC(i).close,'rx');
        end
    end

    for i=(1:length(BTC))
        if(rsi(i)<=in)
            plot(BTC(i).time,BTC(i).close,'go');
        end
    end

    % Buy in, only go to ground buy
    if(Stock==0)
        if(rsi(length(BTC))<=in)
            coin=1.0*money/BTCCNY;
            stockPrice=BTCCNY;
            money=0.0;
            Stock=2;
                totalValue=money+coin*BTCCNY;

            fprintf('%s <strong>Buy</strong> at %.2f\nTotal Assets: %.2f\n',datestr(datetime),BTCCNY,totalValue);
            
        end
    end

    % Sell out, <stopRiskRate, go Up, >sellRate
    if(Stock==1)
        if(rsi(length(BTC))>=100)
            if(BTCCNY>=stockPrice)
             money=coin*BTCCNY;
            coin=0;
            Stock=0;
            totalValue=money+coin*BTCCNY;

            fprintf('%s <strong>Sell</strong> at %.2f\nTotal Assets: %.2f\n',datestr(datetime),BTCCNY,totalValue);
            end
        end
    end
        if(Stock==1)

        if(((BTCCNY-stockPrice)/stockPrice)>sellRate)
            
            money=coin*BTCCNY;
            coin=0;
                totalValue=money+coin*BTCCNY;

            fprintf('%s <strong>Sell</strong> at %.2f\nTotal Assets: %.2f\n',datestr(datetime),BTCCNY,totalValue);
            
            Stock=0;
        end
        end
            if(Stock==1)

        if(((stockPrice-BTCCNY)/stockPrice)>stopLossRate)
            money=coin*BTCCNY;
            coin=0;
            Stock=0;
                totalValue=money+coin*BTCCNY;

            fprintf('%s <strong>Sell</strong> at %.2f\nTotal Assets: %.2f\n',datestr(datetime),BTCCNY,totalValue);
            
        end
            end
            
        
    

    if(Stock==2)
        Stock=1;
    end
    totalValue=money+coin*BTCCNY;
    if(totalValue~=sj(length(sj)))
        sj=[ sj totalValue ];
    end
    pause(interval);
    if(length(BTC)>500)
        BTC(1)=[];
    end
    
    
end

%plot([BTC.time],[rsi*std([BTC.close])/50-0+mean([BTC.close])])
    disp(sj);
