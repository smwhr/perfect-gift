import './style.scss'
import { Story } from 'inkjs';
import storyJson from '../data/Inkjam2021.ink.json';

import pictures from './pictures';

type Medias = { [key in keyof typeof pictures]: InstanceType<typeof Image> }

function isMediaName(name: string) : name is keyof Medias{
  return name in pictures;
}

preload()
  .then((namedImages: NamedImage[]) => {
    setTimeout(() =>
      launch(Object.fromEntries(namedImages) as Medias)
    , 1000)
  })

const WIDTH = 480;
const HEIGHT = 320;


async function preload(){
  const loadList = Object.entries(pictures)

  let pct = 0;
  const pct_element: HTMLDivElement = document.querySelector('#loading_pct')!
  const pct_step = 1/loadList.length*100;
  const incrementLoad = () => {
    pct += pct_step;
    pct_element.innerHTML = pct == 100 ? "Ready !" : `${pct.toFixed(1)}%`
  }

  const loadPromises = loadList.map( ([name, url]) => {

    let resolve: ( (v: NamedImage) => void);
    let reject: ( (reason?: any) => void);

    const promiseImage = new Promise<NamedImage>( (ok, nok) => {
      resolve = ok;
      reject = nok;
    });

    const img = new Image();
          
    img.onload = function () {
      img.width = WIDTH;
      img.height = HEIGHT;
      resolve([name, img])
    }
    img.onerror = function(){
      reject(`Error loading ${name} at ${url}`);
    }
    img.src = url;

    return promiseImage.then( (namedImage: NamedImage) =>{
      incrementLoad();
      return namedImage
    })
  } )

  return Promise.all(loadPromises)
}

function launch(medias: Medias){

  const app = document.querySelector<HTMLDivElement>('#app')!

  const faSignOut = `<svg viewBox="0 0 512 512"><path d="M497 273L329 441c-15 15-41 4.5-41-17v-96H152c-13.3 0-24-10.7-24-24v-96c0-13.3 10.7-24 24-24h136V88c0-21.4 25.9-32 41-17l168 168c9.3 9.4 9.3 24.6 0 34zM192 436v-40c0-6.6-5.4-12-12-12H96c-17.7 0-32-14.3-32-32V160c0-17.7 14.3-32 32-32h84c6.6 0 12-5.4 12-12V76c0-6.6-5.4-12-12-12H96c-53 0-96 43-96 96v192c0 53 43 96 96 96h84c6.6 0 12-5.4 12-12z" fill="#2c3e50"></path></svg>`;

  const story = new Story(storyJson);

  const cover = medias.cover;

  app.innerHTML = `
  <div id="container">
    <div id="status">
       <div id="location">Inkjam 2021</div>
       <div id="exits">
         ${faSignOut}<ul>
           <li><a href="https://smwhr.itch.io/" target="_blanck">itch.io</a></li>
           <li><a href="https://smwhr.net/" target="_blanck">about</a></li>
         </ul>
       </div>
    </div>
    <div id="picture">
      ${cover.outerHTML}
    </div>
    <div id="text">
      <div id="story"></div>
      <div id="choices"></div>
    </div>
  </div>
  `
  const pictureContainer = document.querySelector<HTMLDivElement>('#picture')!
  const imgElement = pictureContainer.querySelector<HTMLImageElement>('img')!;
        pictureContainer.style.minHeight = `${imgElement.clientHeight}px`;

  story.onError = (message, type) => {
    console.log(type, message)
  }
  continueStory(app, story, medias);

}

function showAfter(delay: number, el: HTMLElement){
        el.classList.add("hide");
        setTimeout(function() { el.classList.remove("hide") }, delay);
}

function switchImage(newImage: InstanceType<typeof Image>){
  const pictureContainer = document.querySelector<HTMLDivElement>('#picture')!
  
  newImage.classList.remove("hide");
  newImage.style.position = "absolute";
  newImage.style.top = "0";
  
  pictureContainer.prepend(newImage);

  const images = pictureContainer.querySelectorAll<HTMLImageElement>('img');

  images.forEach( (image, index) => {
    if(index == 0) return;

    const previousImage = image;
    if(index == 1){
      previousImage.classList.add("hide");  
      setTimeout(() => {
        if(previousImage.classList.contains("hide")){
          previousImage.remove();  
        }
      },400)
    }else{
      previousImage.remove();
    }
  });
}

function restart(app: HTMLDivElement, story: InstanceType<typeof Story>, medias: Medias): void {
  story.ResetState();
  switchImage(medias.cover);
  continueStory(app, story, medias);
}

function continueStory(app: HTMLDivElement, story: InstanceType<typeof Story>, medias: Medias): void {

  var locationContainer = app.querySelector<HTMLDivElement>('#status > #location')!;
  var exitsContainer = app.querySelector<HTMLUListElement>('#status > #exits > ul')!;
  var storyContainer = app.querySelector<HTMLDivElement>('#story')!;
  var choicesContainer = app.querySelector<HTMLDivElement>('#choices')!;


  let delay = 0.0;
  while(story.canContinue) {
    const paragraphText = story.Continue();
    const tags = story.currentTags;

    let stopContinue = false;
    if(tags){
      tags.forEach((tagstring: string) => {
        const [tag, value] = tagstring.split(":", 2).map(s => s.trim())
        if(tag == "PICTURE"){
          if(isMediaName(value)){
            switchImage(medias[value])
          } 
        }

        if(tag == "LOCATION"){
          locationContainer.innerHTML = `${value}`
        }

        if( tag == "CLEAR" || tag == "RESTART" ) {
            storyContainer.innerHTML = "";
            exitsContainer.innerHTML = "";
            choicesContainer.innerHTML = "";

            if( tag == "RESTART" ) {
                locationContainer.innerHTML = `Inkjam 2021`
                stopContinue = true;;
                restart(app, story, medias);
                
            }
        }

      })
    }
    if(stopContinue) return;

    if(paragraphText){
      var paragraphElement = document.createElement('p');
          paragraphElement.innerHTML = paragraphText;
          storyContainer.appendChild(paragraphElement);

          showAfter(delay, paragraphElement);
          delay += 200.0;
    }

    story.currentChoices.forEach(function(choice) {

          const choiceText = choice.text;

          const choiceHandler = (event: Event) => {
                                event.preventDefault();
                                if (!(event.target instanceof HTMLElement)) {
                                  return;
                                }
                                let index = parseInt(event.target.dataset["choiceIndex"] ?? "8");
                                exitsContainer.innerHTML = "";
                                choicesContainer.innerHTML = "";
                                story.ChooseChoiceIndex(index);
                                continueStory(app, story, medias);
                                storyContainer.scrollTo(0,storyContainer.scrollHeight);
                            }


          if(choiceText.substr(0, 5) == "exit:"){
            var choiceExitElement = document.createElement('li');
                choiceExitElement.innerHTML = `<a href='#' data-choice-index='${choice.index}'>${choiceText.substr(5)}</a>`
                exitsContainer.appendChild(choiceExitElement);
                choiceExitElement.querySelectorAll("a")
                      .forEach( a => {
                            a.addEventListener("click", choiceHandler)
                      })
                
          }else{
            var choiceParagraphElement = document.createElement('p');
            choiceParagraphElement.classList.add("choice");
            choiceParagraphElement.innerHTML = `<a href='#' data-choice-index='${choice.index}'>${choiceText}</a>`
            choicesContainer.appendChild(choiceParagraphElement);  
            choiceParagraphElement.querySelectorAll("a")
                      .forEach( a => {
                            a.addEventListener("click", choiceHandler)
                      })
            showAfter(delay, choiceParagraphElement);
            delay += 200.0;
          }

          document.querySelectorAll("a[data-choice-index='0']").forEach((elt: Element) => {
            if(! (elt instanceof HTMLElement )) return;
            elt.focus()
          })

    });

  }
  if(exitsContainer.children.length == 0){
    var choiceExitElement = document.createElement('li');
        choiceExitElement.innerHTML = "<span>No exit</span>";
        exitsContainer.appendChild(choiceExitElement);
  }

}

