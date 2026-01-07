
import React from 'react';

interface InfiniteMarqueeProps {
  children: React.ReactNode;
  direction?: 'left' | 'right';
  speed?: number; // Duration in seconds for one full loop
  pauseOnHover?: boolean;
  className?: string;
}

export const InfiniteMarquee: React.FC<InfiniteMarqueeProps> = ({
  children,
  direction = 'left',
  speed = 40,
  pauseOnHover = true,
  className = '',
}) => {
  return (
    <div className={`relative overflow-hidden w-full ${className}`}>
      {/* 
        We inject styles locally to avoid global CSS dependencies for this specific animation.
        The track moves -50% (half its width) to create the seamless loop effect 
        because the content is duplicated exactly once.
      */}
      <style>
        {`
          @keyframes marquee-left {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
          }
          @keyframes marquee-right {
            0% { transform: translateX(-50%); }
            100% { transform: translateX(0%); }
          }
          .animate-marquee-left {
            animation: marquee-left ${speed}s linear infinite;
          }
          .animate-marquee-right {
            animation: marquee-right ${speed}s linear infinite;
          }
          .pause-on-hover:hover {
            animation-play-state: paused;
          }
        `}
      </style>

      <div className="flex w-max">
        <div
          className={`flex w-max ${
            direction === 'left' ? 'animate-marquee-left' : 'animate-marquee-right'
          } ${pauseOnHover ? 'pause-on-hover' : ''}`}
        >
          {/* Original Content */}
          <div className="flex flex-shrink-0 items-center justify-around gap-12 px-6">
            {children}
          </div>
          
          {/* Duplicate Content for Seamless Loop */}
          <div className="flex flex-shrink-0 items-center justify-around gap-12 px-6">
            {children}
          </div>
        </div>
      </div>
    </div>
  );
};
